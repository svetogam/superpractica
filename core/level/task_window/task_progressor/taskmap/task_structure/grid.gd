##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends GridContainer

var _rows: int
var _grid_box_width: int
var _grid_box_height: int
var _grid_box_array := []
@onready var _grid_box_prototype := %GridBoxPrototype as CenterContainer


func _ready() -> void:
	_grid_box_width = int(_grid_box_prototype.size.x + 2)
	_grid_box_height = int(_grid_box_prototype.size.y + 2)


func setup(p_columns: int, p_rows: int) -> void:
	columns = p_columns
	_rows = p_rows

	size = Vector2(columns * _grid_box_width, _rows * _grid_box_height)

	for _column in range(columns):
		var down_column_array = []
		_grid_box_array.append(down_column_array)
		for _row in range(_rows):
			var grid_box = _create_grid_box()
			down_column_array.append(grid_box)

	_populate_grid_with_grid_boxes()


func _create_grid_box() -> Control:
	var grid_box = _grid_box_prototype.duplicate()
	grid_box.show()
	return grid_box


func _populate_grid_with_grid_boxes() -> void:
	for row in range(_rows):
		for column in range(columns):
			add_child(_grid_box_array[column][row])


func add_task_node(task_node: BaseButton, column: int, row: int) -> void:
	_grid_box_array[column][row].add_child(task_node)
	task_node.set_grid_position(column, row)


func is_task_placed(task_node: BaseButton) -> bool:
	return task_node.position != Vector2.ZERO


func get_grid_box_position(column: int, row: int) -> Vector2:
	return _grid_box_array[column][row].position
