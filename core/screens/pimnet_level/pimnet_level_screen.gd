#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name Level
extends Node

signal updated
signal actions_completed
signal exited_to_level_select
signal exited_to_next_level

const REVERTER_MAX_SIZE: int = 1000

var program: LevelProgram
var reverter := CReverter.new()
var _action_queue := LevelActionQueue.new()
@onready var pimnet := %Pimnet as Pimnet
@onready var verifier := $Verifier as Node


func _enter_tree() -> void:
	assert(Game.current_level != null)


func _ready() -> void:
	_action_queue.setup(pimnet)
	_setup_program()
	_setup_reversion()

	pimnet.overlay.exit_pressed.connect(exited_to_level_select.emit)
	pimnet.overlay.next_level_requested.connect(exited_to_next_level.emit)
	verifier.verifications_started.connect(updated.emit)
	verifier.verifications_completed.connect(updated.emit)
	actions_completed.connect(updated.emit)
	CSConnector.with(self).connect_signal(Game.AGENT_FIELD, "updated", updated.emit)
	CSConnector.with(self).connect_signal(Game.AGENT_MEMO_SLOT,
			"memo_changed", updated.emit.unbind(1))

	%LevelStateMachine.activate()
	_run_program()


func _physics_process(_delta: float) -> void:
	# Do actions queued on the same frame together
	_do_queued_actions()


func _setup_program() -> void:
	if Game.current_level.program != null:
		program = Game.current_level.program.instantiate()
		add_child(program)


func _setup_reversion() -> void:
	reverter.history.max_size = REVERTER_MAX_SIZE
	CSLocator.with(self).register(Game.SERVICE_REVERTER, reverter)

	# Initial commit
	if reverter.has_connections():
		reverter.commit()

	# Setup reversion
	%UndoButton.pressed.connect(reverter.undo)
	%RedoButton.pressed.connect(reverter.redo)
	actions_completed.connect(reverter.commit)
	reverter.saved.connect(_update_reversion_buttons)
	reverter.loaded.connect(_update_reversion_buttons)
	if program != null:
		%ResetButton.pressed.connect(program.reset)
		program.reset_changed.connect(_update_reversion_buttons)
		program.reset_called.connect(_do_queued_actions)
		program.set_custom_reset(_default_reset)
	else:
		%ResetButton.pressed.connect(_default_reset)
		%ResetButton.pressed.connect(_do_queued_actions)

	_update_reversion_buttons()
	updated.connect(_update_reversion_buttons)


func _run_program() -> void:
	if program != null:
		program.task_completed.connect(updated.emit.unbind(1))
		program.level_completed.connect(updated.emit)
		program.run()


func _default_reset() -> void:
	for pim in pimnet.get_pim_list():
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
