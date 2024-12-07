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
	TWENTY_BLOCK,
	THIRTY_BLOCK,
	FORTY_BLOCK,
	FIFTY_BLOCK,
}
enum Actions {
	TOGGLE_MARK,
	CREATE_UNIT,
	CREATE_TWO_BLOCK,
	CREATE_THREE_BLOCK,
	CREATE_FOUR_BLOCK,
	CREATE_FIVE_BLOCK,
	CREATE_TEN_BLOCK,
	CREATE_TWENTY_BLOCK,
	CREATE_THIRTY_BLOCK,
	CREATE_FORTY_BLOCK,
	CREATE_FIFTY_BLOCK,
	MOVE_UNIT,
	MOVE_TWO_BLOCK,
	MOVE_THREE_BLOCK,
	MOVE_FOUR_BLOCK,
	MOVE_FIVE_BLOCK,
	MOVE_TEN_BLOCK,
	MOVE_TWENTY_BLOCK,
	MOVE_THIRTY_BLOCK,
	MOVE_FORTY_BLOCK,
	MOVE_FIFTY_BLOCK,
	DELETE_UNIT,
	DELETE_TWO_BLOCK,
	DELETE_THREE_BLOCK,
	DELETE_FOUR_BLOCK,
	DELETE_FIVE_BLOCK,
	DELETE_TEN_BLOCK,
	DELETE_TWENTY_BLOCK,
	DELETE_THIRTY_BLOCK,
	DELETE_FORTY_BLOCK,
	DELETE_FIFTY_BLOCK,
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
const ObjectTwentyBlock := preload("objects/twenty_block/twenty_block.tscn")
const ObjectThirtyBlock := preload("objects/thirty_block/thirty_block.tscn")
const ObjectFortyBlock := preload("objects/forty_block/forty_block.tscn")
const ObjectFiftyBlock := preload("objects/fifty_block/fifty_block.tscn")

const ROWS: int = 10
const COLUMNS: int = 10
const NUMBER_CELLS: int = ROWS * COLUMNS
const BOARD_SIZE := Vector2(350, 350)
const BOARD_GAP := 3.0

var static_model := RectilinearGridModel.new(ROWS, COLUMNS)
var dynamic_model := GridCountingDynamicModel.new(self)
@onready var prefig := %Prefig as Node2D


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


func _dragged_in(object_data: FieldObjectData, point: Vector2, _source: Field) -> void:
	match object_data.field_type:
		"GridCounting":
			match object_data.object_type:
				GridCounting.Objects.UNIT:
					var cell = get_grid_cell_at_point(point)
					GridCountingActionCreateUnit.new(self, cell.number).prefigure()
				GridCounting.Objects.TWO_BLOCK:
					var cells = get_h_adjacent_grid_cells_at_point(point)
					var first_number = cells[0].number
					GridCountingActionCreateTwoBlock.new(self, first_number).prefigure()
				GridCounting.Objects.THREE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 1
					GridCountingActionCreateThreeBlock.new(self, first_number).prefigure()
				GridCounting.Objects.FOUR_BLOCK:
					var cells = get_h_adjacent_grid_cells_at_point(point)
					var first_number = cells[0].number - 1
					GridCountingActionCreateFourBlock.new(self, first_number).prefigure()
				GridCounting.Objects.FIVE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 2
					GridCountingActionCreateFiveBlock.new(self, first_number).prefigure()
				GridCounting.Objects.TEN_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var row_number := static_model.get_row_of_cell(dest_cell.number)
					GridCountingActionCreateTenBlock.new(self, row_number).prefigure()
				GridCounting.Objects.TWENTY_BLOCK:
					var dest_cells = get_v_adjacent_grid_cells_at_point(point)
					var dest_row := static_model.get_row_of_cell(dest_cells[0].number)
					GridCountingActionCreateTwentyBlock.new(self, dest_row).prefigure()
				GridCounting.Objects.THIRTY_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cell.number) - 1
					GridCountingActionCreateThirtyBlock.new(self, dest_row).prefigure()
				GridCounting.Objects.FORTY_BLOCK:
					var dest_cells = get_v_adjacent_grid_cells_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cells[0].number) - 1
					GridCountingActionCreateFortyBlock.new(self, dest_row).prefigure()
				GridCounting.Objects.FIFTY_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cell.number) - 2
					GridCountingActionCreateFiftyBlock.new(self, dest_row).prefigure()


func _received_in(object_data: FieldObjectData, point: Vector2, _source: Field) -> void:
	match object_data.field_type:
		"GridCounting":
			match object_data.object_type:
				GridCounting.Objects.UNIT:
					var cell = get_grid_cell_at_point(point)
					GridCountingActionCreateUnit.new(self, cell.number).push()
				GridCounting.Objects.TWO_BLOCK:
					var cells = get_h_adjacent_grid_cells_at_point(point)
					var first_number = cells[0].number
					GridCountingActionCreateTwoBlock.new(self, first_number).push()
				GridCounting.Objects.THREE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 1
					GridCountingActionCreateThreeBlock.new(self, first_number).push()
				GridCounting.Objects.FOUR_BLOCK:
					var cells = get_h_adjacent_grid_cells_at_point(point)
					var first_number = cells[0].number - 1
					GridCountingActionCreateFourBlock.new(self, first_number).push()
				GridCounting.Objects.FIVE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 2
					GridCountingActionCreateFiveBlock.new(self, first_number).push()
				GridCounting.Objects.TEN_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var row_number := static_model.get_row_of_cell(dest_cell.number)
					GridCountingActionCreateTenBlock.new(self, row_number).push()
				GridCounting.Objects.TWENTY_BLOCK:
					var dest_cells = get_v_adjacent_grid_cells_at_point(point)
					var dest_row := static_model.get_row_of_cell(dest_cells[0].number)
					GridCountingActionCreateTwentyBlock.new(self, dest_row).push()
				GridCounting.Objects.THIRTY_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cell.number) - 1
					GridCountingActionCreateThirtyBlock.new(self, dest_row).push()
				GridCounting.Objects.FORTY_BLOCK:
					var dest_cells = get_v_adjacent_grid_cells_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cells[0].number) - 1
					GridCountingActionCreateFortyBlock.new(self, dest_row).push()
				GridCounting.Objects.FIFTY_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cell.number) - 2
					GridCountingActionCreateFiftyBlock.new(self, dest_row).push()


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
		Objects.TWENTY_BLOCK:
			return dynamic_model.get_twenty_blocks()
		Objects.THIRTY_BLOCK:
			return dynamic_model.get_thirty_blocks()
		Objects.FORTY_BLOCK:
			return dynamic_model.get_forty_blocks()
		Objects.FIFTY_BLOCK:
			return dynamic_model.get_fifty_blocks()
		_:
			assert(false)
			return []


func get_grid_cell_at_point(point: Vector2) -> GridCell:
	for grid_cell in dynamic_model.get_grid_cells():
		if grid_cell.has_point(point):
			return grid_cell
	return null


# Returns 2 horizontally adjacent grid cells closest to point
func get_h_adjacent_grid_cells_at_point(point: Vector2) -> Array:
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


# Returns 2 vertically adjacent grid cells closest to point
func get_v_adjacent_grid_cells_at_point(point: Vector2) -> Array:
	# Make array of cells which have the point at double height
	var grid_cells: Array = []
	var rect: Rect2
	for grid_cell in dynamic_model.get_grid_cells():
		rect = Rect2(
			grid_cell.position.x - grid_cell.size.x / 2,
			grid_cell.position.y - grid_cell.size.y,
			grid_cell.size.x,
			grid_cell.size.y * 2
		)
		if rect.has_point(point):
			grid_cells.append(grid_cell)

	# Add next farthest cell at edges
	if grid_cells.size() == 1:
		var second_cell: GridCell
		if grid_cells[0].number >= 91:
			second_cell = dynamic_model.get_grid_cell(grid_cells[0].number - 10)
			grid_cells.push_front(second_cell)
		elif grid_cells[0].number <= 10:
			second_cell = dynamic_model.get_grid_cell(grid_cells[0].number + 10)
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
func get_grid_cells_by_rows(rows: Array) -> Array:
	var grid_cells: Array = []
	for row in rows:
		var number_array := static_model.get_cells_in_row(row)
		var row_cells := get_grid_cells_by_numbers(number_array)
		grid_cells.append_array(row_cells)
	return grid_cells


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
		GridCounting.Objects.TWENTY_BLOCK:
			return 20
		GridCounting.Objects.THIRTY_BLOCK:
			return 30
		GridCounting.Objects.FORTY_BLOCK:
			return 40
		GridCounting.Objects.FIFTY_BLOCK:
			return 50
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
		if get_grid_cells_by_rows([ten_block.row_number]).has(cell):
			return true
	for twenty_block in dynamic_model.get_twenty_blocks():
		if get_grid_cells_by_rows(twenty_block.row_numbers).has(cell):
			return true
	for thirty_block in dynamic_model.get_thirty_blocks():
		if get_grid_cells_by_rows(thirty_block.row_numbers).has(cell):
			return true
	for forty_block in dynamic_model.get_forty_blocks():
		if get_grid_cells_by_rows(forty_block.row_numbers).has(cell):
			return true
	for fifty_block in dynamic_model.get_fifty_blocks():
		if get_grid_cells_by_rows(fifty_block.row_numbers).has(cell):
			return true
	return false


func is_row_occupied(row: int) -> bool:
	for cell in get_grid_cells_by_rows([row]):
		if is_cell_occupied(cell):
			return true
	return false


func is_cell_marked(cell: GridCell) -> bool:
	assert(cell != null)

	return cell.marked


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


func prefigure_unit(cell_number: int) -> void:
	set_prefig(GridCounting.Objects.UNIT)
	var cell = dynamic_model.get_grid_cell(cell_number)
	prefig.position = Vector2(
		cell.position.x,
		cell.position.y
	)


func prefigure_two_block(first_number: int) -> void:
	set_prefig(GridCounting.Objects.TWO_BLOCK)
	var cell = dynamic_model.get_grid_cell(first_number)
	prefig.position = Vector2(
		cell.position.x + cell.size.x / 2,
		cell.position.y
	)


func prefigure_three_block(first_number: int) -> void:
	set_prefig(GridCounting.Objects.THREE_BLOCK)
	var cell = dynamic_model.get_grid_cell(first_number)
	prefig.position = Vector2(
		cell.position.x + cell.size.x,
		cell.position.y
	)


func prefigure_four_block(first_number: int) -> void:
	set_prefig(GridCounting.Objects.FOUR_BLOCK)
	var cell = dynamic_model.get_grid_cell(first_number)
	prefig.position = Vector2(
		cell.position.x + cell.size.x * 3 / 2,
		cell.position.y
	)


func prefigure_five_block(first_number: int) -> void:
	set_prefig(GridCounting.Objects.FIVE_BLOCK)
	var cell = dynamic_model.get_grid_cell(first_number)
	prefig.position = Vector2(
		cell.position.x + cell.size.x * 2,
		cell.position.y
	)


func prefigure_ten_block(row_number: int) -> void:
	set_prefig(GridCounting.Objects.TEN_BLOCK)
	var cells = get_grid_cells_by_rows([row_number])
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[0].position.y
	)


func prefigure_twenty_block(first_row_number: int) -> void:
	set_prefig(GridCounting.Objects.TWENTY_BLOCK)
	var cells = get_grid_cells_by_rows([
		first_row_number,
		first_row_number + 1,
	])
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[0].position.y + (cells[10].position.y - cells[0].position.y) / 2
	)


func prefigure_thirty_block(first_row_number: int) -> void:
	set_prefig(GridCounting.Objects.THIRTY_BLOCK)
	var cells = get_grid_cells_by_rows([
		first_row_number,
		first_row_number + 1,
		first_row_number + 2,
	])
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[10].position.y
	)


func prefigure_forty_block(first_row_number: int) -> void:
	set_prefig(GridCounting.Objects.FORTY_BLOCK)
	var cells = get_grid_cells_by_rows([
		first_row_number,
		first_row_number + 1,
		first_row_number + 2,
		first_row_number + 3,
	])
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[0].position.y + (cells[30].position.y - cells[0].position.y) / 2
	)


func prefigure_fifty_block(first_row_number: int) -> void:
	set_prefig(GridCounting.Objects.FIFTY_BLOCK)
	var cells = get_grid_cells_by_rows([
		first_row_number,
		first_row_number + 1,
		first_row_number + 2,
		first_row_number + 3,
		first_row_number + 4,
	])
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[20].position.y
	)


func set_prefig(prefig_type: Objects) -> void:
	assert(interface_data.object_data.has(prefig_type))

	clear_prefig()
	prefig.add_child(interface_data.object_data[prefig_type].new_sprite())
	prefig.show()


func clear_prefig() -> void:
	prefig.hide()
	for child in prefig.get_children():
		child.free()


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
	for row_number in range(1, ROWS + 1):
		data[row_number] = {
			"has_ten_block": dynamic_model.get_ten_block(row_number) != null,
			"starts_twenty_block": dynamic_model.get_twenty_block(row_number) != null,
			"starts_thirty_block": dynamic_model.get_thirty_block(row_number) != null,
			"starts_forty_block": dynamic_model.get_forty_block(row_number) != null,
			"starts_fifty_block": dynamic_model.get_fifty_block(row_number) != null,
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
		if row_data[row_number].starts_twenty_block:
			GridCountingActionCreateTwentyBlock.new(self, row_number).push()
		if row_data[row_number].starts_thirty_block:
			GridCountingActionCreateThirtyBlock.new(self, row_number).push()
		if row_data[row_number].starts_forty_block:
			GridCountingActionCreateFortyBlock.new(self, row_number).push()
		if row_data[row_number].starts_fifty_block:
			GridCountingActionCreateFiftyBlock.new(self, row_number).push()


#endregion
