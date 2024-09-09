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

@export var program: LevelProgram
var reverter := CReverter.new()
var _action_queue := LevelActionQueue.new()
var _field_connector := ContextualConnector.new(self, "fields", true)
var _memo_slot_connector := ContextualConnector.new(self, "memo_slots", true)
@onready var pimnet := %Pimnet as Pimnet
@onready var verifier := $Verifier as Node


func _ready() -> void:
	_action_queue.setup(pimnet)
	_setup_reversion()

	pimnet.overlay.exit_pressed.connect(exited_to_level_select.emit)
	pimnet.overlay.next_level_requested.connect(exited_to_next_level.emit)
	verifier.verifications_started.connect(updated.emit)
	verifier.verifications_completed.connect(updated.emit)
	actions_completed.connect(updated.emit)
	_field_connector.connect_signal("updated", updated.emit)
	_memo_slot_connector.connect_signal("memo_changed", updated.emit)

	$StateMachine.activate()
	_run_program()


func _physics_process(_delta: float) -> void:
	# Do actions queued on the same frame together
	_do_queued_actions()


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
	actions_completed.connect(reverter.commit)
	menu.enabler.connect_button("undo", reverter.is_undo_possible)
	menu.enabler.connect_button("redo", reverter.is_redo_possible)
	menu.enabler.connect_general(verifier.is_running, false)
	updated.connect(menu.enabler.update)
	reverter.saved.connect(menu.enabler.update)
	reverter.loaded.connect(menu.enabler.update)
	if program != null:
		menu.reset_pressed.connect(program.reset)
		menu.enabler.connect_button("reset", program.is_reset_possible)
		program.reset_changed.connect(menu.enabler.update)
		program.reset_called.connect(_do_queued_actions)
		program.set_custom_reset(_default_reset)
	else:
		menu.reset_pressed.connect(_default_reset)
		menu.reset_pressed.connect(_do_queued_actions)
	menu.enabler.update()


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
