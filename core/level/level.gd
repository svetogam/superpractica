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
signal level_completed
signal task_started(task_name)
signal task_completed(task_name, is_final)

var pimnet: Pimnet
var _completed := false
var _program: LevelProgram
var _action_queue := LevelActionQueue.new()
var _field_connector := ContextualConnector.new(self, "fields", true)
var _memo_slot_connector := ContextualConnector.new(self, "memo_slots", true)
@onready var side_menu := %SideMenu as VPanelMenu
@onready var verifier := $Verifier as Node
@onready var reversion_control := $ReversionControl as ReversionControl
@onready var task_control := $TaskControl as Node
@onready var effect_layer := %RootEffectLayer as CanvasLayer
@onready var dragged_object_layer := %DraggedObjectLayer as CanvasLayer
@onready var event_control := $EventControl as Node
@onready var _victory_popup := %VictoryPopup as Popup

#====================================================================
# Setup
#====================================================================

func _ready() -> void:
	ContextualLocator.register_property(self, "effect_layer")
	ContextualLocator.register_property(self, "dragged_object_layer")
	ContextualLocator.register_property(self, "task_control")

	_setup_pimnet()
	_action_queue.setup(pimnet)

	side_menu.add_panel(LevelSideMenu.LevelMenuPanels.LEVEL_CONTROL_MENU)
	_setup_reversion()
	_setup_event_menu()

	verifier.verifications_started.connect(_on_verifications_started)
	verifier.verifications_completed.connect(_on_verifications_completed)
	verifier.verifications_started.connect(_signal_update)
	verifier.verifications_completed.connect(_signal_update)
	actions_completed.connect(_signal_update)
	level_completed.connect(_signal_update)
	task_completed.connect(_signal_update)
	_field_connector.connect_signal("updated", _signal_update)
	_memo_slot_connector.connect_signal("memo_changed", _signal_update)

	_run_program()


func _setup_pimnet() -> void:
	var screen := _find_screen()
	if screen != null:
		pimnet = screen
	else:
		pimnet = Pimnet.new()
		add_child(pimnet)

	var offset := Vector2(side_menu.size.x, 0)
	pimnet.set_combined_offset(offset)
	pimnet.input_sequencer.input_processed.connect(_on_input_processed)


func _find_screen() -> Pimnet:
	return ContextUtils.get_child_in_group(self, "superscreens") as Pimnet


func _setup_reversion() -> void:
	if reversion_control.active:
		reversion_control.setup()
		reversion_control.reset_completed.connect(_on_reset_completed)


func _setup_event_menu() -> void:
	if event_control.active:
		event_control.setup()


func _run_program() -> void:
	_program = _find_program()
	if _program != null:
		_program.run()


func _find_program() -> LevelProgram:
	return ContextUtils.get_child_in_group(self, "level_programs")


#====================================================================
# Mechanics
#====================================================================

func _signal_update(_arg1 = null) -> void:
	updated.emit()


func _on_input_processed() -> void:
	if not _action_queue.is_empty():
		_action_queue.flush()
		actions_completed.emit()


func _on_reset_completed() -> void:
	if not _action_queue.is_empty():
		_action_queue.flush()
		actions_completed.emit()


func _on_verifications_started() -> void:
	_update_input_ability()


func _on_verifications_completed() -> void:
	_update_input_ability()


func _update_input_ability() -> void:
	var enable = not verifier.is_running()
	pimnet.input_sequencer.set_enabled(enable)


func complete() -> void:
	if not _completed:
		_completed = true
		_victory_popup.appear()
		level_completed.emit()
