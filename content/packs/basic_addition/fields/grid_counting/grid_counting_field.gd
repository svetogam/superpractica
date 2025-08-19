# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCounting
extends Field

#====================================================================
# Globals
#====================================================================
#region

const ACTION_TOGGLE_MARK := "toggle_mark"
const ACTION_CREATE_UNIT := "create_unit"
const ACTION_CREATE_TWO_BLOCK := "create_two_block"
const ACTION_CREATE_THREE_BLOCK := "create_three_block"
const ACTION_CREATE_FOUR_BLOCK := "create_four_block"
const ACTION_CREATE_FIVE_BLOCK := "create_five_block"
const ACTION_CREATE_TEN_BLOCK := "create_ten_block"
const ACTION_CREATE_TWENTY_BLOCK := "create_twenty_block"
const ACTION_CREATE_THIRTY_BLOCK := "create_thirty_block"
const ACTION_CREATE_FORTY_BLOCK := "create_forty_block"
const ACTION_CREATE_FIFTY_BLOCK := "create_fifty_block"
const ACTION_MOVE_UNIT := "move_unit"
const ACTION_MOVE_TWO_BLOCK := "move_two_block"
const ACTION_MOVE_THREE_BLOCK := "move_three_block"
const ACTION_MOVE_FOUR_BLOCK := "move_four_block"
const ACTION_MOVE_FIVE_BLOCK := "move_five_block"
const ACTION_MOVE_TEN_BLOCK := "move_ten_block"
const ACTION_MOVE_TWENTY_BLOCK := "move_twenty_block"
const ACTION_MOVE_THIRTY_BLOCK := "move_thirty_block"
const ACTION_MOVE_FORTY_BLOCK := "move_forty_block"
const ACTION_MOVE_FIFTY_BLOCK := "move_fifty_block"
const ACTION_DELETE_UNIT := "delete_unit"
const ACTION_DELETE_TWO_BLOCK := "delete_two_block"
const ACTION_DELETE_THREE_BLOCK := "delete_three_block"
const ACTION_DELETE_FOUR_BLOCK := "delete_four_block"
const ACTION_DELETE_FIVE_BLOCK := "delete_five_block"
const ACTION_DELETE_TEN_BLOCK := "delete_ten_block"
const ACTION_DELETE_TWENTY_BLOCK := "delete_twenty_block"
const ACTION_DELETE_THIRTY_BLOCK := "delete_thirty_block"
const ACTION_DELETE_FORTY_BLOCK := "delete_forty_block"
const ACTION_DELETE_FIFTY_BLOCK := "delete_fifty_block"
const ACTION_SET_EMPTY := "set_empty"

const OBJECT_GRID_CELL := "grid_cell"
const OBJECT_UNIT := "unit"
const OBJECT_TWO_BLOCK := "two_block"
const OBJECT_THREE_BLOCK := "three_block"
const OBJECT_FOUR_BLOCK := "four_block"
const OBJECT_FIVE_BLOCK := "five_block"
const OBJECT_TEN_BLOCK := "ten_block"
const OBJECT_TWENTY_BLOCK := "twenty_block"
const OBJECT_THIRTY_BLOCK := "thirty_block"
const OBJECT_FORTY_BLOCK := "forty_block"
const OBJECT_FIFTY_BLOCK := "fifty_block"

const TOOL_CELL_MARKER := "cell_marker"
const TOOL_PIECE_DELETER := "piece_deleter"
const TOOL_PIECE_DRAGGER := "piece_dragger"

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
const CellRingPrefig := preload("cell_ring_prefig.tscn")

const ROWS: int = 10
const COLUMNS: int = 10
const NUMBER_CELLS: int = ROWS * COLUMNS
const BOARD_SIZE := Vector2(350, 350)
const BOARD_GAP := 3.0

static var _interface_data := preload("interface_data.gd").new()
var static_model := RectilinearGridModel.new(ROWS, COLUMNS)
var dynamic_model := GridCountingDynamicModel.new(self)
@onready var prefig := %Prefig as Node2D


static func _get_field_type() -> String:
	return "GridCounting"


static func _get_interface_data() -> FieldInterfaceData:
	return _interface_data


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

	for grid_cell in %Board.get_children():
		number += 1
		dynamic_model.set_grid_cell(number, grid_cell)
		var row = static_model.get_row_of_cell(number)
		var col = static_model.get_column_of_cell(number)
		grid_cell.setup(number, row - 1, col - 1)


func _on_update(_update_type: int) -> void:
	pass


func reset_state() -> void:
	GridCountingActionSetEmpty.new(self).push()


func _dragged_in(object_data: FieldObjectData, point: Vector2, _source: Field) -> void:
	match object_data.field_type:
		"GridCounting":
			match object_data.object_type:
				OBJECT_UNIT:
					var cell = get_grid_cell_at_point(point)
					GridCountingActionCreateUnit.new(self, cell.number).prefigure()
				OBJECT_TWO_BLOCK:
					var cells = get_h_adjacent_grid_cells_at_point(point)
					var first_number = cells[0].number
					GridCountingActionCreateTwoBlock.new(self, first_number).prefigure()
				OBJECT_THREE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 1
					GridCountingActionCreateThreeBlock.new(self, first_number).prefigure()
				OBJECT_FOUR_BLOCK:
					var cells = get_h_adjacent_grid_cells_at_point(point)
					var first_number = cells[0].number - 1
					GridCountingActionCreateFourBlock.new(self, first_number).prefigure()
				OBJECT_FIVE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 2
					GridCountingActionCreateFiveBlock.new(self, first_number).prefigure()
				OBJECT_TEN_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var row_number := static_model.get_row_of_cell(dest_cell.number)
					GridCountingActionCreateTenBlock.new(self, row_number).prefigure()
				OBJECT_TWENTY_BLOCK:
					var dest_cells = get_v_adjacent_grid_cells_at_point(point)
					var dest_row := static_model.get_row_of_cell(dest_cells[0].number)
					GridCountingActionCreateTwentyBlock.new(self, dest_row).prefigure()
				OBJECT_THIRTY_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cell.number) - 1
					GridCountingActionCreateThirtyBlock.new(self, dest_row).prefigure()
				OBJECT_FORTY_BLOCK:
					var dest_cells = get_v_adjacent_grid_cells_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cells[0].number) - 1
					GridCountingActionCreateFortyBlock.new(self, dest_row).prefigure()
				OBJECT_FIFTY_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cell.number) - 2
					GridCountingActionCreateFiftyBlock.new(self, dest_row).prefigure()


func _dragged_out(_object_data: FieldObjectData, _point: Vector2, _source: Field) -> void:
	clear_prefig()


func _received_in(object_data: FieldObjectData, point: Vector2, _source: Field) -> void:
	match object_data.field_type:
		"GridCounting":
			match object_data.object_type:
				OBJECT_UNIT:
					var cell = get_grid_cell_at_point(point)
					GridCountingActionCreateUnit.new(self, cell.number).push()
				OBJECT_TWO_BLOCK:
					var cells = get_h_adjacent_grid_cells_at_point(point)
					var first_number = cells[0].number
					GridCountingActionCreateTwoBlock.new(self, first_number).push()
				OBJECT_THREE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 1
					GridCountingActionCreateThreeBlock.new(self, first_number).push()
				OBJECT_FOUR_BLOCK:
					var cells = get_h_adjacent_grid_cells_at_point(point)
					var first_number = cells[0].number - 1
					GridCountingActionCreateFourBlock.new(self, first_number).push()
				OBJECT_FIVE_BLOCK:
					var first_number = get_grid_cell_at_point(point).number - 2
					GridCountingActionCreateFiveBlock.new(self, first_number).push()
				OBJECT_TEN_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var row_number := static_model.get_row_of_cell(dest_cell.number)
					GridCountingActionCreateTenBlock.new(self, row_number).push()
				OBJECT_TWENTY_BLOCK:
					var dest_cells = get_v_adjacent_grid_cells_at_point(point)
					var dest_row := static_model.get_row_of_cell(dest_cells[0].number)
					GridCountingActionCreateTwentyBlock.new(self, dest_row).push()
				OBJECT_THIRTY_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cell.number) - 1
					GridCountingActionCreateThirtyBlock.new(self, dest_row).push()
				OBJECT_FORTY_BLOCK:
					var dest_cells = get_v_adjacent_grid_cells_at_point(point)
					var dest_row = static_model.get_row_of_cell(dest_cells[0].number) - 1
					GridCountingActionCreateFortyBlock.new(self, dest_row).push()
				OBJECT_FIFTY_BLOCK:
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


func get_objects_by_type(object_type: String) -> Array:
	match object_type:
		OBJECT_GRID_CELL:
			return dynamic_model.get_grid_cells()
		OBJECT_UNIT:
			return dynamic_model.get_units()
		OBJECT_TWO_BLOCK:
			return dynamic_model.get_two_blocks()
		OBJECT_THREE_BLOCK:
			return dynamic_model.get_three_blocks()
		OBJECT_FOUR_BLOCK:
			return dynamic_model.get_four_blocks()
		OBJECT_FIVE_BLOCK:
			return dynamic_model.get_five_blocks()
		OBJECT_TEN_BLOCK:
			return dynamic_model.get_ten_blocks()
		OBJECT_TWENTY_BLOCK:
			return dynamic_model.get_twenty_blocks()
		OBJECT_THIRTY_BLOCK:
			return dynamic_model.get_thirty_blocks()
		OBJECT_FORTY_BLOCK:
			return dynamic_model.get_forty_blocks()
		OBJECT_FIFTY_BLOCK:
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
	# Disregard if point is not over any cell
	if get_grid_cell_at_point(point) == null:
		return []

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
	# Disregard if point is not over any cell
	if get_grid_cell_at_point(point) == null:
		return []

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


func get_object_value(object_type: String) -> int:
	match object_type:
		OBJECT_UNIT:
			return 1
		OBJECT_TWO_BLOCK:
			return 2
		OBJECT_THREE_BLOCK:
			return 3
		OBJECT_FOUR_BLOCK:
			return 4
		OBJECT_FIVE_BLOCK:
			return 5
		OBJECT_TEN_BLOCK:
			return 10
		OBJECT_TWENTY_BLOCK:
			return 20
		OBJECT_THIRTY_BLOCK:
			return 30
		OBJECT_FORTY_BLOCK:
			return 40
		OBJECT_FIFTY_BLOCK:
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
# Info Signals
#====================================================================
#region


func popup_number_by_grid_cell(cell: GridCell) -> NumberSignal:
	return info_signaler.popup_number(cell.number, cell.position, "in_grow")


func stage_piece_warning(piece: FieldObject) -> void:
	piece.set_variant("warning")
	warning_signaler.stage_warning(piece.position)


func remove_piece_warning(piece: FieldObject) -> void:
	piece.set_variant("default")


func prefigure_cell_mark(cell_number: int) -> void:
	clear_prefig()
	prefig.add_child(CellRingPrefig.instantiate())
	prefig.show()

	var cell = dynamic_model.get_grid_cell(cell_number)
	prefig.position = Vector2(cell.position.x, cell.position.y)


func prefigure_unit(cell_number: int) -> void:
	set_prefig(OBJECT_UNIT)
	var cell = dynamic_model.get_grid_cell(cell_number)
	prefig.position = Vector2(cell.position.x, cell.position.y)


func prefigure_two_block(first_number: int) -> void:
	set_prefig(OBJECT_TWO_BLOCK)
	var cell = dynamic_model.get_grid_cell(first_number)
	prefig.position = Vector2(cell.position.x + cell.size.x / 2, cell.position.y)


func prefigure_three_block(first_number: int) -> void:
	set_prefig(OBJECT_THREE_BLOCK)
	var cell = dynamic_model.get_grid_cell(first_number)
	prefig.position = Vector2(cell.position.x + cell.size.x, cell.position.y)


func prefigure_four_block(first_number: int) -> void:
	set_prefig(OBJECT_FOUR_BLOCK)
	var cell = dynamic_model.get_grid_cell(first_number)
	prefig.position = Vector2(cell.position.x + cell.size.x * 3 / 2, cell.position.y)


func prefigure_five_block(first_number: int) -> void:
	set_prefig(OBJECT_FIVE_BLOCK)
	var cell = dynamic_model.get_grid_cell(first_number)
	prefig.position = Vector2(cell.position.x + cell.size.x * 2, cell.position.y)


func prefigure_ten_block(row_number: int) -> void:
	set_prefig(OBJECT_TEN_BLOCK)
	var cells = get_grid_cells_by_rows([row_number])
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[0].position.y
	)


func prefigure_twenty_block(first_row_number: int) -> void:
	set_prefig(OBJECT_TWENTY_BLOCK)
	var cells = get_grid_cells_by_rows(
		[
			first_row_number,
			first_row_number + 1,
		]
	)
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[0].position.y + (cells[10].position.y - cells[0].position.y) / 2
	)


func prefigure_thirty_block(first_row_number: int) -> void:
	set_prefig(OBJECT_THIRTY_BLOCK)
	var cells = get_grid_cells_by_rows(
		[
			first_row_number,
			first_row_number + 1,
			first_row_number + 2,
		]
	)
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[10].position.y
	)


func prefigure_forty_block(first_row_number: int) -> void:
	set_prefig(OBJECT_FORTY_BLOCK)
	var cells = get_grid_cells_by_rows(
		[
			first_row_number,
			first_row_number + 1,
			first_row_number + 2,
			first_row_number + 3,
		]
	)
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[0].position.y + (cells[30].position.y - cells[0].position.y) / 2
	)


func prefigure_fifty_block(first_row_number: int) -> void:
	set_prefig(OBJECT_FIFTY_BLOCK)
	var cells = get_grid_cells_by_rows(
		[
			first_row_number,
			first_row_number + 1,
			first_row_number + 2,
			first_row_number + 3,
			first_row_number + 4,
		]
	)
	prefig.position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[20].position.y
	)


func set_prefig(prefig_type: String) -> void:
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


func _on_reverter_saving(memento: CRMemento) -> void:
	var data := {
		"cells": _get_cells_data(),
		"rows": _get_rows_data(),
	}
	memento.add_submemento(name, data)


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


func _on_reverter_loading(memento: CRMemento) -> void:
	var data = memento.get_submemento(name)
	GridCountingActionSetEmpty.new(self).push()
	_load_cell_data(data.cells)
	_load_row_data(data.rows)


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
