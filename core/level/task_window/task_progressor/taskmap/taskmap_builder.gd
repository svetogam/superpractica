##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends RefCounted

var _task_structure: Control
var _data: Object


func build_by_data(p_task_structure: Control, p_data: Object) -> void:
	_task_structure = p_task_structure
	_data = p_data

	_task_structure.task_positions_set.connect(_on_task_positions_set)
	var columns = _data.get_number_of_columns()
	var rows = _data.get_number_of_rows()
	_task_structure.setup_grid(columns, rows)
	_create_tasks()


func _create_tasks() -> void:
	for id in _data.get_ids():
		_create_task_by_id(id)


func _create_task_by_id(id: String) -> void:
	var label = _data.get_name_for_id(id)
	var grid_x = _data.get_grid_position_for_id(id).x
	var grid_y = _data.get_grid_position_for_id(id).y
	_task_structure.create_task(id, label, grid_x, grid_y)


func _on_task_positions_set() -> void:
	_connect_tasks()


func _connect_tasks() -> void:
	for task in _task_structure.get_tasks():
		_connect_task_with_previous(task)


func _connect_task_with_previous(task: BaseButton) -> void:
	var previous_ids = _data.get_previous_for_id(task.id)
	for previous_task_id in previous_ids:
		var previous_task = _task_structure.get_task_by_id(previous_task_id)
		_task_structure.create_arrow_from_task_to_task(previous_task, task)
