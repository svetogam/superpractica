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
			"three_block": null,
			"four_block": null,
			"five_block": null,
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
		GridCounting.Actions.CREATE_THREE_BLOCK:
			_cells[action.first_number].three_block = action.block
		GridCounting.Actions.CREATE_FOUR_BLOCK:
			_cells[action.first_number].four_block = action.block
		GridCounting.Actions.CREATE_FIVE_BLOCK:
			_cells[action.first_number].five_block = action.block
		GridCounting.Actions.CREATE_TEN_BLOCK:
			_rows[action.row_number].ten_block = action.block
		GridCounting.Actions.MOVE_UNIT:
			_cells[action.from_cell_number].unit = null
			_cells[action.to_cell_number].unit = action.unit
		GridCounting.Actions.MOVE_TWO_BLOCK:
			_cells[action.from_first_number].two_block = null
			_cells[action.to_first_number].two_block = action.block
		GridCounting.Actions.MOVE_THREE_BLOCK:
			_cells[action.from_first_number].three_block = null
			_cells[action.to_first_number].three_block = action.block
		GridCounting.Actions.MOVE_FOUR_BLOCK:
			_cells[action.from_first_number].four_block = null
			_cells[action.to_first_number].four_block = action.block
		GridCounting.Actions.MOVE_FIVE_BLOCK:
			_cells[action.from_first_number].five_block = null
			_cells[action.to_first_number].five_block = action.block
		GridCounting.Actions.MOVE_TEN_BLOCK:
			_rows[action.from_row_number].ten_block = null
			_rows[action.to_row_number].ten_block = action.block
		GridCounting.Actions.DELETE_UNIT:
			_cells[action.cell_number].unit = null
		GridCounting.Actions.DELETE_TWO_BLOCK:
			_cells[action.first_number].two_block = null
		GridCounting.Actions.DELETE_THREE_BLOCK:
			_cells[action.first_number].three_block = null
		GridCounting.Actions.DELETE_FOUR_BLOCK:
			_cells[action.first_number].four_block = null
		GridCounting.Actions.DELETE_FIVE_BLOCK:
			_cells[action.first_number].five_block = null
		GridCounting.Actions.DELETE_TEN_BLOCK:
			_rows[action.row_number].ten_block = null
		GridCounting.Actions.SET_EMPTY:
			for cell_number in _cells:
				_cells[cell_number].unit = null
				_cells[cell_number].two_block = null
				_cells[cell_number].three_block = null
				_cells[cell_number].four_block = null
				_cells[cell_number].five_block = null
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
	var blocks: Array = []
	for cell_number in _cells:
		var block = get_two_block(cell_number)
		if block != null:
			blocks.append(block)
	return blocks


func get_three_block(cell_number: int) -> FieldObject:
	return _cells[cell_number].three_block


func get_three_blocks() -> Array:
	var blocks: Array = []
	for cell_number in _cells:
		var block = get_three_block(cell_number)
		if block != null:
			blocks.append(block)
	return blocks


func get_four_block(cell_number: int) -> FieldObject:
	return _cells[cell_number].four_block


func get_four_blocks() -> Array:
	var blocks: Array = []
	for cell_number in _cells:
		var block = get_four_block(cell_number)
		if block != null:
			blocks.append(block)
	return blocks


func get_five_block(cell_number: int) -> FieldObject:
	return _cells[cell_number].five_block


func get_five_blocks() -> Array:
	var blocks: Array = []
	for cell_number in _cells:
		var block = get_five_block(cell_number)
		if block != null:
			blocks.append(block)
	return blocks


func get_ten_block(row_number: int) -> FieldObject:
	return _rows[row_number].ten_block


func get_ten_blocks() -> Array:
	var blocks: Array = []
	for row_number in _rows:
		var block = get_ten_block(row_number)
		if block != null:
			blocks.append(block)
	return blocks


func get_blocks() -> Array:
	var blocks := get_two_blocks()
	blocks.append_array(get_three_blocks())
	blocks.append_array(get_four_blocks())
	blocks.append_array(get_five_blocks())
	blocks.append_array(get_ten_blocks())
	return blocks
