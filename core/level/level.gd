##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

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
onready var side_menu := $"%SideMenu"
onready var verifier := $Verifier
onready var metanavig_control := $MetanavigControl
onready var task_control := $TaskControl
onready var effect_layer := $"%RootEffectLayer"
onready var dragged_object_layer := $"%DraggedObjectLayer"
onready var event_control := $EventControl
onready var _victory_popup := $"%VictoryPopup"

#####################################################################
# Setup
#####################################################################

func _ready() -> void:
	ContextualLocator.register_property(self, "effect_layer")
	ContextualLocator.register_property(self, "dragged_object_layer")
	ContextualLocator.register_property(self, "task_control")

	_setup_pimnet()
	_action_queue.setup(pimnet)

	side_menu.add_panel(LevelSideMenu.LevelMenuPanels.LEVEL_CONTROL_MENU)
	_setup_metanavig()
	_setup_event_menu()

	verifier.connect("verifications_started", self, "_on_verifications_started")
	verifier.connect("verifications_completed", self, "_on_verifications_completed")
	verifier.connect("verifications_started", self, "_signal_update")
	verifier.connect("verifications_completed", self, "_signal_update")
	connect("actions_completed", self, "_signal_update")
	connect("level_completed", self, "_signal_update")
	connect("task_completed", self, "_signal_update")
	_field_connector.connect_signal("updated", self, "_signal_update")
	_memo_slot_connector.connect_signal("memo_changed", self, "_signal_update")

	_run_program()


func _setup_pimnet() -> void:
	var screen = _find_screen()
	if screen != null:
		pimnet = screen
	else:
		pimnet = Pimnet.new()
		add_child(pimnet)

	var offset = Vector2(side_menu.rect_size.x, 0)
	pimnet.set_offset(offset)
	pimnet.input_sequencer.connect("input_processed", self, "_on_input_processed")


func _find_screen() -> Pimnet:
	return ContextUtils.get_child_in_group(self, "superscreens") as Pimnet


func _setup_metanavig() -> void:
	if metanavig_control.active:
		metanavig_control.setup()
		metanavig_control.connect("reset_completed", self, "_on_reset_completed")


func _setup_event_menu() -> void:
	if event_control.active:
		event_control.setup()


func _run_program() -> void:
	_program = _find_program()
	if _program != null:
		_program.run()


func _find_program() -> Node:
	return ContextUtils.get_child_in_group(self, "level_programs")


#####################################################################
# Mechanics
#####################################################################

func _signal_update(_arg1=null) -> void:
	emit_signal("updated")


func _on_input_processed() -> void:
	if not _action_queue.is_empty():
		_action_queue.flush()
		emit_signal("actions_completed")


func _on_reset_completed() -> void:
	if not _action_queue.is_empty():
		_action_queue.flush()
		emit_signal("actions_completed")


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
		emit_signal("level_completed")
