#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends RefCounted

signal replacements_changed

var _data: Dictionary
var _instruction_replacements: Dictionary


func setup(p_data: Dictionary, p_instruction_replacements := {}) -> void:
	assert(_data.keys().is_empty())
	_data = p_data
	_instruction_replacements = p_instruction_replacements


func set_instruction_replacements(p_instruction_replacements := {}) -> void:
	_instruction_replacements = p_instruction_replacements
	replacements_changed.emit()


func get_ids() -> Array:
	return _data.keys()


func get_number_of_columns() -> int:
	var max_column_position: int = 0
	for id in get_ids():
		var column_position: int = _data[id].grid_position.x
		if column_position > max_column_position:
			max_column_position = column_position
	return max_column_position + 1


func get_number_of_rows() -> int:
	var max_row_position: int = 0
	for id in get_ids():
		var row_position: int = _data[id].grid_position.y
		if row_position > max_row_position:
			max_row_position = row_position
	return max_row_position + 1


func get_name_for_id(id: String) -> String:
	return _data[id].name


func get_grid_position_for_id(id: String) -> Vector2:
	return _data[id].grid_position


func get_instructions_for_id(id: String) -> String:
	var instructions: String = _data[id].instructions
	return instructions.format(_instruction_replacements)


func get_previous_for_id(id: String) -> Array:
	return _data[id].previous


func get_flags_for_id(id: String) -> Array:
	return _data[id].flags


func is_task_initial(id: String) -> bool:
	return _data[id].flags.has("initial")


func is_task_final(id: String) -> bool:
	return _data[id].flags.has("final")


func get_next_for_id(id: String) -> Array:
	var next_list: Array = []
	for id2 in get_ids():
		var previous := get_previous_for_id(id2)
		if previous.has(id):
			next_list.append(id2)
	return next_list


func get_single_next_for_id(id: String) -> String:
	var next_list := get_next_for_id(id)
	assert(next_list.size() == 1)
	return next_list[0]


func get_initial_task() -> String:
	return _get_task_by_unique_flag("initial")


func get_final_task() -> String:
	return _get_task_by_unique_flag("final")


func _get_task_by_unique_flag(unique_flag: String) -> String:
	var flagged_tasks: Array = []
	for id in _data.keys():
		if _data[id].flags.has(unique_flag):
			flagged_tasks.append(id)

	assert(flagged_tasks.size() == 1)
	return flagged_tasks[0]
