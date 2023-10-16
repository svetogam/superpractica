##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Node

export(GDScript) var _taskmap_data: GDScript
var _level: Node
var _current_task: String
var _data_reader := preload("taskmap_data_reader.gd").new()


func _enter_tree() -> void:
	_level = get_parent()

	if _taskmap_data != null:
		_data_reader.setup(_taskmap_data.DATA)
		var initial_task = _data_reader.get_initial_task()
		_set_current_task(initial_task)


func set_instruction_replacements(replacements: Dictionary) -> void:
	_data_reader.set_instruction_replacements(replacements)


func complete_current_task() -> void:
	if _taskmap_data != null:
		_level.emit_signal("task_completed", _current_task)
		var is_final = _data_reader.is_task_final(_current_task)
		if is_final:
			_level.complete()
		else:
			var next_task = _data_reader.get_single_next_for_id(_current_task)
			_set_current_task(next_task)
	else:
		_level.complete()


func _set_current_task(task_name: String) -> void:
	_current_task = task_name
	_level.emit_signal("task_started", _current_task)


func get_data_reader() -> Reference:
	return _data_reader


func get_current_task() -> String:
	return _current_task
