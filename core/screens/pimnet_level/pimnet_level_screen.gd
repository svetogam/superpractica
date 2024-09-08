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
signal reset_changed
signal exited_to_level_select
signal exited_to_next_level

const REVERTER_MAX_SIZE: int = 1000

@export var program: LevelProgram
var reverter := CReverter.new()
var _action_queue := LevelActionQueue.new()
var _reset_function := _default_reset
var _field_connector := ContextualConnector.new(self, "fields", true)
var _memo_slot_connector := ContextualConnector.new(self, "memo_slots", true)
@onready var pimnet := %Pimnet as Pimnet
@onready var verifier := $Verifier as Node

#====================================================================
# Setup
#====================================================================

func _ready() -> void:
	_action_queue.setup(pimnet)
	_setup_reversion()

	pimnet.overlay.exit_pressed.connect(exited_to_level_select.emit)
	pimnet.overlay.next_level_requested.connect(exited_to_next_level.emit)
	verifier.verifications_started.connect(_signal_update)
	verifier.verifications_completed.connect(_signal_update)
	actions_completed.connect(_signal_update)
	_field_connector.connect_signal("updated", _signal_update)
	_memo_slot_connector.connect_signal("memo_changed", _signal_update)

	$StateMachine.activate()
	_run_program()


func _physics_process(_delta: float) -> void:
	# Bundle actions occuring on the same frame to flush together
	if not _action_queue.is_empty():
		_action_queue.flush()
		actions_completed.emit()


func _setup_reversion() -> void:
	reverter.history.max_size = REVERTER_MAX_SIZE
	CSLocator.with(self).register(Game.SERVICE_REVERTER, reverter)

	# Initial commit
	if reverter.has_connections():
		reverter.commit()

	# Setup reversion menu
	var menu = pimnet.overlay.reversion_menu
	menu.undo_pressed.connect(reverter.undo)
	menu.redo_pressed.connect(reverter.redo)
	menu.reset_pressed.connect(reset)
	actions_completed.connect(reverter.commit)
	menu.enabler.connect_button("undo", reverter.is_undo_possible)
	menu.enabler.connect_button("redo", reverter.is_redo_possible)
	menu.enabler.connect_button("reset", _is_reset_possible)
	menu.enabler.connect_general(verifier.is_running, false)
	updated.connect(menu.enabler.update)
	reverter.saved.connect(menu.enabler.update)
	reverter.loaded.connect(menu.enabler.update)
	reset_changed.connect(menu.enabler.update)
	menu.enabler.update()


func _run_program() -> void:
	if program != null:
		program.task_completed.connect(_signal_update)
		program.level_completed.connect(_signal_update)
		program.run()


#====================================================================
# Mechanics
#====================================================================

func _signal_update(_arg1 = null) -> void:
	updated.emit()


func reset() -> void:
	if not _reset_function.is_null():
		_reset_function.call()

	# Flush actions queued by the reset function immediately
	if not _action_queue.is_empty():
		_action_queue.flush()
		actions_completed.emit()


func set_no_reset() -> void:
	_reset_function = Callable()
	reset_changed.emit()


func set_default_reset() -> void:
	_reset_function = _default_reset
	reset_changed.emit()


func set_custom_reset(callable: Callable) -> void:
	_reset_function = callable
	reset_changed.emit()


func _default_reset() -> void:
	for pim in pimnet.get_pim_list():
		pim.reset()


func _is_reset_possible() -> bool:
	return not _reset_function.is_null()
