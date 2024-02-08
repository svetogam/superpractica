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

var pimnet: Pimnet
var _program: LevelProgram
var _action_queue := LevelActionQueue.new()
var _field_connector := ContextualConnector.new(self, "fields", true)
var _memo_slot_connector := ContextualConnector.new(self, "memo_slots", true)
@onready var pimnet_screen_gui := %PimnetScreenGui as Control
@onready var verifier := $Verifier as Node
@onready var reversion_control := $ReversionControl as ReversionControl
@onready var effect_layer := %RootEffectLayer as CanvasLayer
@onready var dragged_object_layer := %DraggedObjectLayer as CanvasLayer

#====================================================================
# Setup
#====================================================================

func _ready() -> void:
	ContextualLocator.register_property(self, "effect_layer")
	ContextualLocator.register_property(self, "dragged_object_layer")

	_setup_pimnet()
	_action_queue.setup(pimnet)

	_setup_reversion()
	_setup_goal_panel()
	_setup_tool_panel()
	_setup_creation_panel()

	verifier.verifications_started.connect(_on_verifications_started)
	verifier.verifications_completed.connect(_on_verifications_completed)
	verifier.verifications_started.connect(_signal_update)
	verifier.verifications_completed.connect(_signal_update)
	actions_completed.connect(_signal_update)
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

	pimnet.input_sequencer.input_processed.connect(_on_input_processed)


func _find_screen() -> Pimnet:
	return ContextUtils.get_child_in_group(self, "superscreens") as Pimnet


func _setup_reversion() -> void:
	reversion_control.setup()
	reversion_control.reset_completed.connect(_on_reset_completed)


func _setup_goal_panel() -> void:
	pimnet_screen_gui.goal_panel.add_check_condition(verifier.is_running, false)
	updated.connect(pimnet_screen_gui.goal_panel.enabler.update)


# Currently only works if all pims have the same field
func _setup_tool_panel() -> void:
	if pimnet.get_pim_list().size() > 0:
		var first_pim = pimnet.get_pim_list()[0]
		pimnet_screen_gui.tool_panel.setup(first_pim.field.interface_data)

		# Connect panel and fields
		for pim in pimnet.get_pim_list():
			if pim.field.get_field_type() == first_pim.field.get_field_type():
				pimnet_screen_gui.tool_panel.tool_selected.connect(pim.field.set_tool)
				pim.field.tool_changed.connect(pimnet_screen_gui.tool_panel.set_tool)


# Currently only works if all pims are the same type
func _setup_creation_panel() -> void:
	if pimnet.get_pim_list().size() > 0:
		var first_pim = pimnet.get_pim_list()[0]
		pimnet_screen_gui.creation_panel.setup(first_pim.field.interface_data)

		# Connect to pimnet
		pimnet_screen_gui.creation_panel.object_grabbed.connect(
				pimnet.create_interfield_object_by_type.bind(
				first_pim.field.interface_data))


func _run_program() -> void:
	_program = _find_program()
	if _program != null:
		_program.task_completed.connect(_signal_update)
		_program.level_completed.connect(_signal_update)
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
