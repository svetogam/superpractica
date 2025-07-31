# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingDynamicModel
extends RefCounted

var field: Field
var _cells: Dictionary #[int, [String, FieldObject]]
var _rows: Dictionary #[int, [String, FieldObject]]


func _init(p_field: GridCounting) -> void:
	field = p_field
	field.action_done.connect(_on_action)

	for cell_number in range(1, field.NUMBER_CELLS + 1):
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
			"ten_block": null,
			"twenty_block": null,
			"thirty_block": null,
			"forty_block": null,
			"fifty_block": null,
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
		GridCounting.Actions.CREATE_TWENTY_BLOCK:
			_rows[action.first_row_number].twenty_block = action.block
		GridCounting.Actions.CREATE_THIRTY_BLOCK:
			_rows[action.first_row_number].thirty_block = action.block
		GridCounting.Actions.CREATE_FORTY_BLOCK:
			_rows[action.first_row_number].forty_block = action.block
		GridCounting.Actions.CREATE_FIFTY_BLOCK:
			_rows[action.first_row_number].fifty_block = action.block
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
		GridCounting.Actions.MOVE_TWENTY_BLOCK:
			_rows[action.from_first_row_number].twenty_block = null
			_rows[action.to_first_row_number].twenty_block = action.block
		GridCounting.Actions.MOVE_THIRTY_BLOCK:
			_rows[action.from_first_row_number].thirty_block = null
			_rows[action.to_first_row_number].thirty_block = action.block
		GridCounting.Actions.MOVE_FORTY_BLOCK:
			_rows[action.from_first_row_number].forty_block = null
			_rows[action.to_first_row_number].forty_block = action.block
		GridCounting.Actions.MOVE_FIFTY_BLOCK:
			_rows[action.from_first_row_number].fifty_block = null
			_rows[action.to_first_row_number].fifty_block = action.block
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
		GridCounting.Actions.DELETE_TWENTY_BLOCK:
			_rows[action.first_row_number].twenty_block = null
		GridCounting.Actions.DELETE_THIRTY_BLOCK:
			_rows[action.first_row_number].thirty_block = null
		GridCounting.Actions.DELETE_FORTY_BLOCK:
			_rows[action.first_row_number].forty_block = null
		GridCounting.Actions.DELETE_FIFTY_BLOCK:
			_rows[action.first_row_number].fifty_block = null
		GridCounting.Actions.SET_EMPTY:
			for cell_number in _cells:
				_cells[cell_number].unit = null
				_cells[cell_number].two_block = null
				_cells[cell_number].three_block = null
				_cells[cell_number].four_block = null
				_cells[cell_number].five_block = null
			for row_number in _rows:
				_rows[row_number].ten_block = null
				_rows[row_number].twenty_block = null
				_rows[row_number].thirty_block = null
				_rows[row_number].forty_block = null
				_rows[row_number].fifty_block = null


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


func get_twenty_block(row_number: int) -> FieldObject:
	return _rows[row_number].twenty_block


func get_twenty_blocks() -> Array:
	var blocks: Array = []
	for row_number in _rows:
		var block = get_twenty_block(row_number)
		if block != null:
			blocks.append(block)
	return blocks


func get_thirty_block(row_number: int) -> FieldObject:
	return _rows[row_number].thirty_block


func get_thirty_blocks() -> Array:
	var blocks: Array = []
	for row_number in _rows:
		var block = get_thirty_block(row_number)
		if block != null:
			blocks.append(block)
	return blocks


func get_forty_block(row_number: int) -> FieldObject:
	return _rows[row_number].forty_block


func get_forty_blocks() -> Array:
	var blocks: Array = []
	for row_number in _rows:
		var block = get_forty_block(row_number)
		if block != null:
			blocks.append(block)
	return blocks


func get_fifty_block(row_number: int) -> FieldObject:
	return _rows[row_number].fifty_block


func get_fifty_blocks() -> Array:
	var blocks: Array = []
	for row_number in _rows:
		var block = get_fifty_block(row_number)
		if block != null:
			blocks.append(block)
	return blocks


func get_blocks() -> Array:
	var blocks := get_two_blocks()
	blocks.append_array(get_three_blocks())
	blocks.append_array(get_four_blocks())
	blocks.append_array(get_five_blocks())
	blocks.append_array(get_ten_blocks())
	blocks.append_array(get_twenty_blocks())
	blocks.append_array(get_thirty_blocks())
	blocks.append_array(get_forty_blocks())
	blocks.append_array(get_fifty_blocks())
	return blocks


# Returns the list in order of increasing occupied cell numbers.
func get_pieces() -> Array:
	var pieces: Array = []
	var piece: FieldObject
	var cell_number: int = 1
	for i in _cells:
		if cell_number > _cells.size():
			break
		var row_number = field.static_model.get_row_of_cell(cell_number)
		if get_unit(cell_number) != null:
			piece = get_unit(cell_number)
			cell_number += 1
		elif get_two_block(cell_number) != null:
			piece = get_two_block(cell_number)
			cell_number += 2
		elif get_three_block(cell_number) != null:
			piece = get_three_block(cell_number)
			cell_number += 3
		elif get_four_block(cell_number) != null:
			piece = get_four_block(cell_number)
			cell_number += 4
		elif get_five_block(cell_number) != null:
			piece = get_five_block(cell_number)
			cell_number += 5
		elif get_ten_block(row_number) != null:
			piece = get_ten_block(row_number)
			cell_number += 10
		elif get_twenty_block(row_number) != null:
			piece = get_twenty_block(row_number)
			cell_number += 20
		elif get_thirty_block(row_number) != null:
			piece = get_thirty_block(row_number)
			cell_number += 30
		elif get_forty_block(row_number) != null:
			piece = get_forty_block(row_number)
			cell_number += 40
		elif get_fifty_block(row_number) != null:
			piece = get_fifty_block(row_number)
			cell_number += 50
		else:
			cell_number += 1
			continue
		pieces.append(piece)
	return pieces
