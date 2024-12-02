#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCounting
extends Field

#====================================================================
# Globals
#====================================================================
#region

enum Objects {
	GRID_CELL,
	UNIT,
	TWO_BLOCK,
	THREE_BLOCK,
	FOUR_BLOCK,
	FIVE_BLOCK,
	TEN_BLOCK,
}
enum Actions {
	TOGGLE_MARK,
	CREATE_UNIT,
	CREATE_TWO_BLOCK,
	CREATE_THREE_BLOCK,
	CREATE_FOUR_BLOCK,
	CREATE_FIVE_BLOCK,
	CREATE_TEN_BLOCK,
	MOVE_UNIT,
	MOVE_TWO_BLOCK,
	MOVE_THREE_BLOCK,
	MOVE_FOUR_BLOCK,
	MOVE_FIVE_BLOCK,
	MOVE_TEN_BLOCK,
	DELETE_UNIT,
	DELETE_TWO_BLOCK,
	DELETE_THREE_BLOCK,
	DELETE_FOUR_BLOCK,
	DELETE_FIVE_BLOCK,
	DELETE_TEN_BLOCK,
	SET_EMPTY,
}
enum Tools {
	NONE = Game.NO_TOOL,
	CELL_MARKER,
	UNIT_CREATOR,
	PIECE_DELETER,
	PIECE_DRAGGER,
}

const ObjectGridCell := preload("objects/grid_cell/grid_cell.tscn")
const ObjectUnit := preload("objects/unit/unit.tscn")
const ObjectTwoBlock := preload("objects/two_block/two_block.tscn")
const ObjectThreeBlock := preload("objects/three_block/three_block.tscn")
const ObjectFourBlock := preload("objects/four_block/four_block.tscn")
const ObjectFiveBlock := preload("objects/five_block/five_block.tscn")
const ObjectTenBlock := preload("objects/ten_block/ten_block.tscn")

const ROWS: int = 10
const COLUMNS: int = 10
const NUMBER_CELLS: int = ROWS * COLUMNS
const BOARD_SIZE := Vector2(350, 350)
const BOARD_GAP := 3.0

var static_model := RectilinearGridModel.new(ROWS, COLUMNS)
var dynamic_model := GridCountingDynamicModel.new(self)


static func _get_field_type() -> String:
	return "GridCounting"


static func _get_interface_data() -> FieldInterfaceData:
	return preload("interface_data.gd").new()


#endregion
#====================================================================
# Behavior
#====================================================================
#region

func _ready() -> void:
	super()
	_setup_board()


func _setup_board() -> void:
	# Add grid cells
	var number: int = 0
	var grid_cell: GridCell
	for row in range(ROWS):
		for col in range(COLUMNS):
			number += 1
			grid_cell = ObjectGridCell.instantiate() as GridCell
			add_child(grid_cell)
			grid_cell.setup(number, row, col)


func _on_update(_update_type: int) -> void:
	pass


func reset_state() -> void:
	GridCountingActionSetEmpty.new(self).push()


func _received_in(object_data: FieldObjectData, point: Vector2, _source: Field) -> void:
	match object_data.field_type:
		"GridCounting":
			match object_data.object_type:
				GridCounting.Objects.UNIT:
					var cell = get_grid_cell_at_point(point)
					if cell != null:
						GridCountingActionCreateUnit.new(self, cell.number).push()
				GridCounting.Objects.TWO_BLOCK:
					var first_number = get_2_grid_cells_at_point(point)[0].number
					GridCountingActionCreateTwoBlock.new(self, first_number).push()
				GridCounting.Objects.THREE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 1
					GridCountingActionCreateThreeBlock.new(self, first_number).push()
				GridCounting.Objects.FOUR_BLOCK:
					var first_number = get_2_grid_cells_at_point(point)[0].number - 1
					GridCountingActionCreateFourBlock.new(self, first_number).push()
				GridCounting.Objects.FIVE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 2
					GridCountingActionCreateFiveBlock.new(self, first_number).push()
				GridCounting.Objects.TEN_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var row_number := static_model.get_row_of_cell(dest_cell.number)
					GridCountingActionCreateTenBlock.new(self, row_number).push()


#endregion
#====================================================================
# Queries
#====================================================================
#region

#--------------------------------------
# Object-Finding
#--------------------------------------

func get_objects_by_type(object_type: int) -> Array:
	match object_type:
		Objects.GRID_CELL:
			return dynamic_model.get_grid_cells()
		Objects.UNIT:
			return dynamic_model.get_units()
		Objects.TWO_BLOCK:
			return dynamic_model.get_two_blocks()
		Objects.THREE_BLOCK:
			return dynamic_model.get_three_blocks()
		Objects.FOUR_BLOCK:
			return dynamic_model.get_four_blocks()
		Objects.FIVE_BLOCK:
			return dynamic_model.get_five_blocks()
		Objects.TEN_BLOCK:
			return dynamic_model.get_ten_blocks()
		_:
			assert(false)
			return []


func get_grid_cell_at_point(point: Vector2) -> GridCell:
	for grid_cell in dynamic_model.get_grid_cells():
		if grid_cell.has_point(point):
			return grid_cell
	return null


# Returns 2 horizontally connected grid cells closest to point
func get_2_grid_cells_at_point(point: Vector2) -> Array:
	# Make array of cells which have the point at double width
	var grid_cells: Array = []
	var rect: Rect2
	for grid_cell in dynamic_model.get_grid_cells():
		rect = Rect2(
			grid_cell.position.x - grid_cell.size.x,
			grid_cell.position.y - grid_cell.size.y / 2,
			grid_cell.size.x * 2,
			grid_cell.size.y
		)
		if rect.has_point(point):
			grid_cells.append(grid_cell)

	# Add next farthest cell at edges
	if grid_cells.size() == 1:
		var second_cell: GridCell
		if grid_cells[0].number % 10 == 0:
			second_cell = dynamic_model.get_grid_cell(grid_cells[0].number - 1)
			grid_cells.push_front(second_cell)
		elif grid_cells[0].number % 10 == 1:
			second_cell = dynamic_model.get_grid_cell(grid_cells[0].number + 1)
			grid_cells.append(second_cell)
		else:
			assert(false)
			return []

	return grid_cells


func get_grid_cells_by_numbers(number_list: Array) -> Array:
	var grid_cells: Array = []
	for number in number_list:
		var grid_cell := dynamic_model.get_grid_cell(number)
		grid_cells.append(grid_cell)
	return grid_cells


# Row numbers start at 1
func get_grid_cells_by_row(row: int) -> Array:
	assert(row > 0 and row <= 10)

	var number_array := static_model.get_cells_in_row(row)
	return get_grid_cells_by_numbers(number_array)


func get_marked_cell() -> GridCell:
	for cell in dynamic_model.get_grid_cells():
		if cell.marked:
			return cell
	return null


func get_grid_cells_with_units() -> Array:
	var cells: Array = []
	var units := dynamic_model.get_units()
	for unit in units:
		cells.append(unit.cell)
	return cells


#--------------------------------------
# Analysis
#--------------------------------------

func get_object_value(object_type: GridCounting.Objects) -> int:
	match object_type:
		GridCounting.Objects.UNIT:
			return 1
		GridCounting.Objects.TWO_BLOCK:
			return 2
		GridCounting.Objects.THREE_BLOCK:
			return 3
		GridCounting.Objects.FOUR_BLOCK:
			return 4
		GridCounting.Objects.FIVE_BLOCK:
			return 5
		GridCounting.Objects.TEN_BLOCK:
			return 10
		_:
			assert(false)
			return -1


func is_cell_occupied(cell: GridCell) -> bool:
	assert(cell != null)

	if cell.has_unit():
		return true
	for two_block in dynamic_model.get_two_blocks():
		if two_block.cells.has(cell):
			return true
	for three_block in dynamic_model.get_three_blocks():
		if three_block.cells.has(cell):
			return true
	for four_block in dynamic_model.get_four_blocks():
		if four_block.cells.has(cell):
			return true
	for five_block in dynamic_model.get_five_blocks():
		if five_block.cells.has(cell):
			return true
	for ten_block in dynamic_model.get_ten_blocks():
		if get_grid_cells_by_row(ten_block.row_number).has(cell):
			return true
	return false


func is_row_occupied(row: int) -> bool:
	for cell in get_grid_cells_by_row(row):
		if is_cell_occupied(cell):
			return true
	return false


func is_cell_marked(cell: GridCell) -> bool:
	assert(cell != null)

	return cell.marked


func get_numbers_with_units() -> Array:
	var numbers: Array = []
	var cells := get_grid_cells_with_units()
	for cell in cells:
		numbers.append(cell.number)
	numbers.sort()
	return numbers


func does_number_have_unit(number: int) -> bool:
	return get_numbers_with_units().has(number)


func does_row_have_ten_block(row_number: int) -> bool:
	for ten_block in dynamic_model.get_ten_blocks():
		if ten_block.row_number == row_number:
			return true
	return false


func get_contiguous_numbers_with_units_from(first_number: int) -> Array:
	var number_sequence: Array = []
	var number := first_number
	while number < 200:
		if does_number_have_unit(number):
			number_sequence.append(number)
			number += 1
		else:
			return number_sequence
	return number_sequence


func get_contiguous_rows_with_ten_blocks_from(first_row: int) -> Array:
	var row_sequence: Array = []
	for row_number in range(first_row, 11):
		if does_row_have_ten_block(row_number):
			row_sequence.append(row_number)
			row_number += 1
		else:
			break
	return row_sequence


func get_contiguous_occupied_numbers_from(first_number: int) -> Array:
	var number_sequence: Array = []
	var number := first_number
	while number <= 100:
		var cell: GridCell = dynamic_model.get_grid_cell(number)
		if is_cell_occupied(cell):
			number_sequence.append(number)
			number += 1
		else:
			return number_sequence
	return number_sequence


func get_marked_numbers() -> Array:
	var cell := get_marked_cell()
	if cell != null:
		return [cell.number]
	else:
		return []


#endregion
#====================================================================
# Effects
#====================================================================
#region

func give_number_effect_by_grid_cell(cell: GridCell) -> NumberEffect:
	return math_effects.give_number(cell.number, cell.global_position, "grow")


func count_piece(piece: FieldObject) -> NumberEffect:
	return effect_counter.count_next(piece.global_position)


func stage_piece_warning(piece: FieldObject) -> void:
	piece.set_variant("warning")
	warning_effects.stage_warning(piece.position)


func remove_piece_warning(piece: FieldObject) -> void:
	piece.set_variant("default")


#endregion
#====================================================================
# History
#====================================================================
#region

#--------------------------------------
# State Building
#--------------------------------------

func build_state() -> CRMemento:
	return CRMemento.new({
		"cells": _get_cells_data(),
		"rows": _get_rows_data(),
	})


func _get_cells_data() -> Dictionary:
	var data := {}
	for cell in dynamic_model.get_grid_cells():
		data[cell.number] = {
			"marked": cell.marked,
			"has_unit": cell.has_unit(),
			"starts_two_block": dynamic_model.get_two_block(cell.number) != null,
			"starts_three_block": dynamic_model.get_three_block(cell.number) != null,
			"starts_four_block": dynamic_model.get_four_block(cell.number) != null,
			"starts_five_block": dynamic_model.get_five_block(cell.number) != null,
		}
	return data


func _get_rows_data() -> Dictionary:
	var data := {}
	for ten_block in dynamic_model.get_ten_blocks():
		data[ten_block.row_number] = {
			"has_ten_block": true,
		}
	return data


#--------------------------------------
# State Loading
#--------------------------------------

func load_state(state: CRMemento) -> void:
	GridCountingActionSetEmpty.new(self).push()

	_load_cell_data(state.data.cells)
	_load_row_data(state.data.rows)

	_trigger_update(UpdateTypes.STATE_LOADED)


func _load_cell_data(cell_data: Dictionary) -> void:
	for cell_number in cell_data.keys():
		if cell_data[cell_number].marked:
			GridCountingActionToggleMark.new(self, cell_number).push()
		if cell_data[cell_number].has_unit:
			GridCountingActionCreateUnit.new(self, cell_number).push()
		if cell_data[cell_number].starts_two_block:
			GridCountingActionCreateTwoBlock.new(self, cell_number).push()
		if cell_data[cell_number].starts_three_block:
			GridCountingActionCreateThreeBlock.new(self, cell_number).push()
		if cell_data[cell_number].starts_four_block:
			GridCountingActionCreateFourBlock.new(self, cell_number).push()
		if cell_data[cell_number].starts_five_block:
			GridCountingActionCreateFiveBlock.new(self, cell_number).push()


func _load_row_data(row_data: Dictionary) -> void:
	for row_number in row_data.keys():
		if row_data[row_number].has_ten_block:
			GridCountingActionCreateTenBlock.new(self, row_number).push()


#endregion
