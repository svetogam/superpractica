##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Control

signal task_selected(task)
signal task_positions_set()

const TaskmapNode := preload("task_node.tscn")
const TaskmapArrow := preload("arrow.tscn")
var _button_group := ButtonGroup.new()
var _tasks_placed := false
@onready var _grid := %Grid as GridContainer


func setup_grid(columns: int, rows: int) -> void:
	_grid.setup(columns, rows)


func create_task(id: String, label: String, column: int, row: int) -> BaseButton:
	var task = TaskmapNode.instantiate()
	_grid.add_task_node(task, column, row)
	task.id = id
	task.structure = self
	task.button_group = _button_group
	task.set_label(label)
	task.toggled.connect(_on_task_toggled)
	return task


func _process(_delta: float) -> void:
	if not _tasks_placed and _are_all_tasks_placed_in_grid():
		task_positions_set.emit()
		_tasks_placed = true


func _are_all_tasks_placed_in_grid() -> bool:
	for task in get_tasks():
		if not _grid.is_task_placed(task):
			return false
	return true


func create_arrow_from_task_to_task(source_task: BaseButton, dest_task: BaseButton) -> void:
	var arrow = TaskmapArrow.instantiate()
	add_child(arrow)
	arrow.set_arrow(source_task, dest_task)


func select_task(task_id: String) -> void:
	var task = get_task_by_id(task_id)
	if not task.button_pressed:
		task.button_pressed = true


func _on_task_toggled(task_pressed: bool) -> void:
	if task_pressed:
		var task = get_selected_task()
		task_selected.emit(task)


func get_selected_task() -> BaseButton:
	return _button_group.get_pressed_button()


func get_task_by_id(task_id: String) -> BaseButton:
	for task in get_tasks():
		if task.id == task_id:
			return task
	assert(false)
	return null


func get_tasks() -> Array:
	return get_tree().get_nodes_in_group("taskmap_nodes")


func get_structure_size() -> Vector2:
	return _grid.size


func get_task_position(task: BaseButton) -> Vector2:
	var grid_box_position = _grid.get_grid_box_position(task.grid_position.x, task.grid_position.y)
	var task_offset = task.position
	var task_x = grid_box_position.x + task_offset.x
	var task_y = grid_box_position.y + task_offset.y
	return Vector2(task_x, task_y)
