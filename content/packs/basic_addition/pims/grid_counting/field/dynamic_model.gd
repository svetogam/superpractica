#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingDynamicModel
extends RefCounted

var _cells: Dictionary #[int, [String, FieldObject]]
var _rows: Dictionary #[int, [String, FieldObject]]


func _init(field: GridCounting) -> void:
	field.action_queue.action_done.connect(_on_action)

	for cell_number in range(1, field.ROWS * field.COLUMNS + 1):
		_cells[cell_number] = {
			"grid_cell": null,
			"unit": null,
			"two_block": null,
		}
	for row_number in range(1, field.ROWS + 1):
		_rows[row_number] = {
			"ten_block": null
		}


func _on_action(action: FieldAction) -> void:
	match action.name:
		GridCounting.Actions.CREATE_UNIT:
			_cells[action.cell_number].unit = action.unit
		GridCounting.Actions.CREATE_TWO_BLOCK:
			_cells[action.first_number].two_block = action.block
		GridCounting.Actions.CREATE_TEN_BLOCK:
			_rows[action.row_number].ten_block = action.block
		GridCounting.Actions.MOVE_UNIT:
			_cells[action.from_cell_number].unit = null
			_cells[action.to_cell_number].unit = action.unit
		GridCounting.Actions.MOVE_TWO_BLOCK:
			_cells[action.from_first_number].two_block = null
			_cells[action.to_first_number].two_block = action.block
		GridCounting.Actions.MOVE_TEN_BLOCK:
			_rows[action.from_row_number].ten_block = null
			_rows[action.to_row_number].ten_block = action.block
		GridCounting.Actions.DELETE_UNIT:
			_cells[action.cell_number].unit = null
		GridCounting.Actions.DELETE_TWO_BLOCK:
			_cells[action.first_number].two_block = null
		GridCounting.Actions.DELETE_TEN_BLOCK:
			_rows[action.row_number].ten_block = null
		GridCounting.Actions.SET_EMPTY:
			for cell_number in _cells:
				_cells[cell_number].unit = null
				_cells[cell_number].two_block = null
			for row_number in _rows:
				_rows[row_number].ten_block = null


func set_grid_cell(cell_number: int, grid_cell: GridCell) -> void:
	_cells[cell_number].grid_cell = grid_cell


func get_grid_cell(cell_number: int) -> GridCell:
	return _cells[cell_number].grid_cell


func get_grid_cells() -> Array:
	var grid_cells: Array = []
	for cell_number in _cells:
		var grid_cell = get_grid_cell(cell_number)
		if grid_cell != null:
			grid_cells.append(grid_cell)
	return grid_cells


func get_unit(cell_number: int) -> FieldObject:
	return _cells[cell_number].unit


func get_units() -> Array:
	var units: Array = []
	for cell_number in _cells:
		var unit = get_unit(cell_number)
		if unit != null:
			units.append(unit)
	return units


func get_two_block(cell_number: int) -> FieldObject:
	return _cells[cell_number].two_block


func get_two_blocks() -> Array:
	var two_blocks: Array = []
	for cell_number in _cells:
		var two_block = get_two_block(cell_number)
		if two_block != null:
			two_blocks.append(two_block)
	return two_blocks


func get_ten_block(row_number: int) -> FieldObject:
	return _rows[row_number].ten_block


func get_ten_blocks() -> Array:
	var ten_blocks: Array = []
	for row_number in _rows:
		var ten_block = get_ten_block(row_number)
		if ten_block != null:
			ten_blocks.append(ten_block)
	return ten_blocks
