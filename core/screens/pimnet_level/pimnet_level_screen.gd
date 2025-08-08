# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Level
extends Node

signal updated
signal actions_completed

const REVERTER_MAX_SIZE: int = 1000
@export var level_data: LevelResource
var program: LevelProgram
var reverter := CReverter.new()
var _action_queue := LevelActionQueue.new()
@onready var pimnet := %Pimnet as Pimnet


func _ready() -> void:
	# Setup reversion
	reverter.history.max_size = REVERTER_MAX_SIZE
	%UndoButton.pressed.connect(reverter.undo)
	%RedoButton.pressed.connect(reverter.redo)
	%ResetButton.pressed.connect(_on_reset_button_pressed)
	actions_completed.connect(reverter.commit)
	reverter.saved.connect(_update_reversion_buttons)
	reverter.loaded.connect(_update_reversion_buttons)
	_update_reversion_buttons()
	updated.connect(_update_reversion_buttons)
	CSLocator.with(self).register(Game.SERVICE_REVERTER, reverter)
	actions_completed.connect(updated.emit)
	CSConnector.with(self).connect_signal(Game.AGENT_FIELD, "updated", updated.emit)
	CSConnector.with(self).connect_signal(
		Game.AGENT_MEMO_SLOT, "memo_changed", updated.emit.unbind(1)
	)

	# Consistently start with empty state
	pimnet.setup(null)

	# Load immediately if level data is already set
	if level_data != null:
		load_level(level_data)


func _physics_process(_delta: float) -> void:
	# Do actions queued on the same frame together
	_do_queued_actions()


func load_level(p_level_data: LevelResource) -> void:
	assert(level_data == null)
	assert(p_level_data != null)

	level_data = p_level_data
	CSLocator.with(self).register(Game.SERVICE_LEVEL_DATA, level_data)
	pimnet.setup(level_data)

	# Initial commit
	if reverter.has_connected_funcs():
		reverter.commit()

	_action_queue.setup(pimnet)

	# Set up and run program
	if level_data.program != null:
		program = level_data.program.instantiate()
		program.level = self
		program._setup_vars(level_data.program_vars)
		program.task_completed.connect(updated.emit.unbind(1))
		program.level_completed.connect(updated.emit)
		program.level_completed.connect($StateChart.send_event.bind("complete"))
		program.verification_started.connect(updated.emit)
		program.verification_started.connect(
			$StateChart.send_event.bind("start_verification")
		)
		program.verification_stopped.connect(updated.emit)
		program.verification_stopped.connect(
			$StateChart.send_event.bind("stop_verification")
		)
		program.reset_changed.connect(_update_reversion_buttons)
		program.reset_called.connect(_do_queued_actions)
		program.set_custom_reset(_default_reset)

		add_child(program)

	# Not immediate due to potential for calling from _ready()
	$StateChart.send_event.call_deferred("load")


func unload_level() -> void:
	assert(level_data != null)

	$StateChart.send_event("unload")

	reverter.history.clear()

	# Unload pimnet stuff
	_action_queue.reset()
	pimnet.setup(null)
	_action_queue.setup(pimnet)

	# Unload program
	if program != null:
		program.queue_free()
		program = null

	level_data = null
	CSLocator.with(self).unregister(Game.SERVICE_LEVEL_DATA)


func _on_reset_button_pressed() -> void:
	if program != null:
		program.reset()
	else:
		_default_reset()
		_do_queued_actions()


func _default_reset() -> void:
	for pim in pimnet.pims:
		pim.reset()


func _do_queued_actions() -> void:
	if not _action_queue.is_empty():
		_action_queue.flush()
		actions_completed.emit()


func _update_reversion_buttons() -> void:
	%UndoButton.disabled = (
		(program != null and program.is_verifying()) or not reverter.is_undo_possible()
	)
	%RedoButton.disabled = (
		(program != null and program.is_verifying()) or not reverter.is_redo_possible()
	)
	%ResetButton.disabled = (
		program != null and (program.is_verifying() or not program.is_reset_possible())
	)


func _on_empty_state_entered() -> void:
	if pimnet.overlay.goal_panel != null:
		pimnet.overlay.goal_panel.reset()
	if program != null and program.is_verifying():
		pimnet.disable_verification_input(false)


func _on_verifying_state_entered() -> void:
	pimnet.overlay.goal_panel.start_verification()
	pimnet.disable_verification_input(true)


func _on_verifying_state_exited() -> void:
	pimnet.disable_verification_input(false)


func _on_verifying_to_playing_taken() -> void:
	pimnet.overlay.goal_panel.stop_verification()
	pimnet.overlay.goal_panel.fail()


func _on_completed_state_entered() -> void:
	pimnet.overlay.goal_panel.succeed()
	Game.progress_data.record_level_completion(level_data.id)
	%Overlay/StateChart.send_event("open_completion_modal")


#====================================================================
# Verifications
#====================================================================

const PRE_CHECK_DELAY := 0.1
const POST_CHECK_DELAY := 0.8
var _row_numbers: Array
var _number_signal: NumberSignal
var _inequality_signals: Array  #[InfoSignal]
var _rows_checked: int = 0
var _success_callback: Callable
var _failure_callback := Callable()


func verify_equality(
	p_number_signal: NumberSignal,
	p_row_numbers: Array,
	p_success_callback: Callable,
	p_failure_callback := Callable()
) -> void:
	_row_numbers = p_row_numbers
	_number_signal = p_number_signal
	_success_callback = p_success_callback
	_failure_callback = p_failure_callback
	_rows_checked = 0
	$StateChart.set_expression_property("pre_check_delay", PRE_CHECK_DELAY)
	$StateChart.set_expression_property("post_check_delay", POST_CHECK_DELAY)
	$StateChart.send_event("verify_equality")


func _on_running_state_exited() -> void:
	for inequality_signal in _inequality_signals:
		inequality_signal.free()
	_inequality_signals.clear()


func _on_prepare_row_state_entered() -> void:
	var row_number = _get_row_number()
	var slot = %SolutionVerificationPanel.right_slots[row_number]
	pimnet.move_signal_to_slot(
		_number_signal, slot, $StateChart.send_event.bind("decide_row")
	)


func _on_check_row_state_entered() -> void:
	var row_number = _get_row_number()
	var got_memo := IntegerMemo.new(_number_signal.number)
	var wanted_memo = %SolutionVerificationPanel.left_slots[row_number].memo
	var equal = got_memo.value == wanted_memo.value
	if equal:
		%SolutionVerificationPanel.affirm_in_row(got_memo, row_number)
		_number_signal.erase("out_merge")

		var check_slot = %SolutionVerificationPanel.check_slots[row_number]
		var overlay_position = check_slot.get_global_rect().get_center()
		var signal_position = pimnet.overlay_position_to_effect_layer(overlay_position)
		pimnet.info_signaler.affirm(signal_position + InfoSignaler.NEAR_OFFSET)
		_rows_checked += 1

		$StateChart.send_event("decide_row_equal")
	else:
		if _row_numbers.size() == 1:
			%SolutionVerificationPanel.reject_in_row(got_memo, row_number)
			_number_signal.erase("out_merge")

		var check_slot = %SolutionVerificationPanel.check_slots[row_number]
		var overlay_position = check_slot.get_global_rect().get_center()
		var signal_position = pimnet.overlay_position_to_effect_layer(overlay_position)
		var inequality_signal = pimnet.info_signaler.popup_inequality(signal_position)
		_inequality_signals.append(inequality_signal)
		_rows_checked += 1

		$StateChart.send_event("decide_row_unequal")


func _on_equal_state_entered() -> void:
	$StateChart.send_event("stop_verifying_equality")
	_success_callback.call()


func _on_unequal_state_entered() -> void:
	if _rows_checked < _row_numbers.size():
		$StateChart.send_event("verify_next_row")
	else:
		$StateChart.send_event("stop_verifying_equality")
		_failure_callback.call()


func _get_row_number() -> int:
	assert(_row_numbers.size() >= _rows_checked)

	return _row_numbers[_rows_checked]
