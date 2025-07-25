# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Level
extends Node

signal updated
signal actions_completed

const REVERTER_MAX_SIZE: int = 1000
const EMPTY_PIMNET_SETUP := preload("pimnet/empty_pimnet_setup.tres")
@export var level_data: LevelResource
var program: LevelProgram
var reverter := CReverter.new()
var _action_queue := LevelActionQueue.new()
@onready var pimnet := %Pimnet as Pimnet
@onready var verifier := $Verifier as Node


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

	# Connect signals
	verifier.started.connect(_on_verifier_started)
	verifier.completed.connect(_on_verifier_completed)
	actions_completed.connect(updated.emit)
	CSConnector.with(self).connect_signal(Game.AGENT_FIELD, "updated", updated.emit)
	CSConnector.with(self).connect_signal(Game.AGENT_MEMO_SLOT,
			"memo_changed", updated.emit.unbind(1))

	# Consistently start with empty state
	pimnet.setup(EMPTY_PIMNET_SETUP)

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
	pimnet.setup(level_data.pimnet_setup)

	# Initial commit
	if reverter.has_connected_funcs():
		reverter.commit()

	_action_queue.setup(pimnet)

	# Set up and run program
	if level_data.program != null:
		program = level_data.program.instantiate()
		add_child(program)
		program.task_completed.connect(updated.emit.unbind(1))
		program.level_completed.connect(updated.emit)
		program.level_completed.connect(_on_program_level_completed)
		program.reset_changed.connect(_update_reversion_buttons)
		program.reset_called.connect(_do_queued_actions)
		program.set_custom_reset(_default_reset)
		program.run()

	$StateChart.send_event("load")


func unload_level() -> void:
	assert(level_data != null)

	$StateChart.send_event("unload")

	reverter.history.clear()

	# Unload pimnet stuff
	_action_queue.reset()
	pimnet.setup(EMPTY_PIMNET_SETUP)
	_action_queue.setup(pimnet)

	# Unload program
	if program != null:
		if program.is_running():
			program.stop()
		program.free()

	level_data = null
	CSLocator.with(self).unregister(Game.SERVICE_LEVEL_DATA)


func _on_program_level_completed() -> void:
	$StateChart.send_event("complete")


func _on_verifier_started() -> void:
	updated.emit()
	$StateChart.send_event("start_verification")


func _on_verifier_completed() -> void:
	updated.emit()
	$StateChart.send_event("stop_verification")


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
	%UndoButton.disabled = verifier.is_running() or not reverter.is_undo_possible()
	%RedoButton.disabled = verifier.is_running() or not reverter.is_redo_possible()
	%ResetButton.disabled = (
		verifier.is_running() or (program != null and not program.is_reset_possible())
	)


#==========================================================
# State Behavior
#==========================================================

func _on_empty_state_entered() -> void:
	if pimnet.overlay.goal_panel != null:
		pimnet.overlay.goal_panel.reset()
	if verifier.is_running():
		verifier.abort()
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
	%OverlayStateMachine.change_state("Completion")
