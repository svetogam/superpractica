##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends WindowContent

var _data_reader: Reference
var _locator := ContextualLocator.new(self)
onready var _taskmap := preload("taskmap/taskmap.tscn").instance()
onready var _viewer := $"%Viewer"
onready var _instruction_box := $"%InstructionBox"


func _ready() -> void:
	_viewer.set_subscreen(_taskmap)
	_locator.auto_callback("task_control", self, "_on_found_task_control")


func _on_found_task_control(task_control: Node) -> void:
	_data_reader = task_control.get_data_reader()
	_taskmap.setup(_data_reader)

	_data_reader.connect("replacements_changed", self, "_update_instructions")
	_taskmap.connect("task_selected", self, "_update_instructions")
	_update_instructions()

	var level = ContextUtils.get_parent_in_group(self, "levels")
	level.connect("task_started", _taskmap, "select_task")
	level.connect("task_completed", _taskmap, "complete_task")


func _update_instructions(_dummy=null) -> void:
	assert(_data_reader != null)
	var task_id = _taskmap.get_selected_task_id()
	var instruction_text = _data_reader.get_instructions_for_id(task_id)
	_instruction_box.set_text(instruction_text)
