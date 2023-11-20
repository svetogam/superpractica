##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Subscreen

signal task_selected(task_id)

var _taskmap_builder := preload("taskmap_builder.gd").new()
@onready var _task_structure := %TaskStructure as Control


func setup(data_reader: RefCounted) -> void:
	_task_structure.task_selected.connect(_on_task_selected)
	_taskmap_builder.build_by_data(_task_structure, data_reader)
	set_rect(Vector2.ZERO, _task_structure.get_structure_size())

	var initial_task_id = data_reader.get_initial_task()
	_task_structure.select_task(initial_task_id)


func _on_task_selected(task: BaseButton) -> void:
	task_selected.emit(task.id)


func complete_task(task_id: String) -> void:
	var task_node = _task_structure.get_task_by_id(task_id)
	task_node.set_completed()


func select_task(task_id: String) -> void:
	_task_structure.select_task(task_id)


func get_selected_task_id() -> String:
	var task = _task_structure.get_selected_task()
	return task.id
