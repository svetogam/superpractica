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
	TEN_BLOCK,
}
enum Tools {
	NONE = Game.NO_TOOL,
	CELL_MARKER,
	UNIT_CREATOR,
	PIECE_DELETER,
	PIECE_DRAGGER,
}
enum CellMarks {
	ALL = 0,
	UNIT,
	HIGHLIGHT,
}

const ObjectGridCell := preload("objects/grid_cell/grid_cell.tscn")
const ObjectUnit := preload("objects/unit/unit.tscn")
const ObjectTenBlock := preload("objects/ten_block/ten_block.tscn")

const ProcessCountUnits := preload("processes/count_units.gd")

const BOARD_SIZE := Vector2(350, 350)
const BOARD_GAP := 3.0

var _grid_cells_dict: Dictionary = {} # {GridCell.number: GridCell, ...}
var _units_dict: Dictionary = {} # {Unit.cell.number: Unit, ...}


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
	for row in range(10):
		for col in range(10):
			number += 1
			grid_cell = ObjectGridCell.instantiate() as GridCell
			add_child(grid_cell)
			grid_cell.setup(number, row, col)
			_grid_cells_dict[number] = grid_cell


func _on_update(_update_type: int) -> void:
	pass


func reset_state() -> void:
	push_action(set_empty)


func _incoming_drop(object_data: FieldObjectData, point: Vector2, _source: Field) -> void:
	match object_data.field_type:
		"GridCounting":
			match object_data.object_type:
				GridCounting.Objects.UNIT:
					_accept_incoming_unit(point)
				GridCounting.Objects.TEN_BLOCK:
					var dest_cell = get_grid_cell_at_point(point)
					var row_number: int = get_row_number_for_cell_number(
							dest_cell.number)
					push_action(create_ten_block.bind(row_number))
		"BubbleSum":
			match object_data.object_type:
				BubbleSum.Objects.UNIT:
					_accept_incoming_unit(point)


func _accept_incoming_unit(point: Vector2) -> void:
	var cell = get_grid_cell_at_point(point)
	if cell != null and not is_cell_occupied(cell):
		push_action(create_unit.bind(cell))


func _outgoing_drop(object: FieldObject) -> void:
	match object.object_type:
		GridCounting.Objects.UNIT:
			push_action(delete_unit.bind(object))
		GridCounting.Objects.TEN_BLOCK:
			push_action(delete_block.bind(object))


func _on_unit_number_changed(old_number: int, new_number: int, unit: FieldObject) -> void:
	if old_number != -1:
		_units_dict.erase(old_number)
	if new_number != -1:
		_units_dict[new_number] = unit


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
			return get_grid_cell_list()
		Objects.UNIT:
			return get_unit_list()
		Objects.TEN_BLOCK:
			return get_ten_block_list()
		_:
			assert(false)
			return []


func get_grid_cell_list() -> Array:
	return _grid_cells_dict.values()


func get_unit_list(sort_ascending := false) -> Array:
	if not sort_ascending:
		return _units_dict.values()
	else:
		var units: Array = []
		var numbers := get_numbers_with_units()
		for number in numbers:
			units.append(_units_dict[number])
		return units


func get_ten_block_list() -> Array:
	return get_objects_in_group("ten_blocks")


func get_grid_cell(number: int) -> GridCell:
	if _grid_cells_dict.has(number):
		return _grid_cells_dict[number]
	return null


func get_unit(number: int) -> FieldObject:
	if _units_dict.has(number):
		return _units_dict[number]
	return null


# Row numbers start at 1
func get_ten_block(row_number: int) -> FieldObject:
	for ten_block in get_ten_block_list():
		if ten_block.row_number == row_number:
			return ten_block
	return null


func get_grid_cell_at_point(point: Vector2) -> GridCell:
	for grid_cell in get_grid_cell_list():
		if grid_cell.has_point(point):
			return grid_cell
	return null


func get_grid_cells_by_numbers(number_list: Array) -> Array:
	var grid_cells: Array = []
	for number in number_list:
		var grid_cell := get_grid_cell(number)
		grid_cells.append(grid_cell)
	return grid_cells


# Row numbers start at 1
func get_grid_cells_by_row(row: int) -> Array:
	assert(row > 0 and row <= 10)

	var first_number := get_first_number_in_row(row)
	var last_number := get_last_number_in_row(row)
	var number_array := range(first_number, last_number + 1)
	return get_grid_cells_by_numbers(number_array)


func get_highlighted_grid_cell() -> GridCell:
	for cell in get_grid_cell_list():
		if cell.highlighted:
			return cell
	return null


func is_any_cell_highlighted() -> bool:
	return get_highlighted_grid_cell() != null


func get_grid_cells_with_units() -> Array:
	var cells: Array = []
	var units := get_unit_list()
	for unit in units:
		if not cells.has(unit.cell):
			cells.append(unit.cell)
	return cells


#--------------------------------------
# Analysis
#--------------------------------------

static func get_numbers() -> Array:
	return range(1, 101)


static func get_first_number_in_row(row: int) -> int:
	assert(row > 0 and row <= 10)

	return get_last_number_in_row(row) - 9


static func get_last_number_in_row(row: int) -> int:
	assert(row > 0 and row <= 10)

	return row * 10


# Row numbers start at 1
static func get_row_number_for_cell_number(number: int) -> int:
	assert(number > 0 and number <= 100)

	var n: int = 0
	n += IntegerMath.get_hundreds_digit(number) * 10
	n += IntegerMath.get_tens_digit(number)
	if IntegerMath.get_ones_digit(number) != 0:
		n += 1
	return n


func is_cell_occupied(cell: GridCell) -> bool:
	assert(cell != null)

	if cell.has_unit():
		return true
	for ten_block in get_ten_block_list():
		if get_grid_cells_by_row(ten_block.row_number).has(cell):
			return true
	return false


func is_row_occupied(row: int) -> bool:
	for cell in get_grid_cells_by_row(row):
		if is_cell_occupied(cell):
			return true
	return false


func is_cell_highlighted(cell: GridCell) -> bool:
	assert(cell != null)

	return cell.highlighted


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
	for ten_block in get_ten_block_list():
		if ten_block.row_number == row_number:
			return true
	return false


static func get_numbers_between(start_number: int, end_number: int, skip_count_tens: bool
) -> Array:
	if skip_count_tens:
		if end_number >= start_number + 10:
			var numbers: Array = []
			numbers += get_numbers_by_skip_count(start_number, 10, end_number)
			if numbers[-1] == end_number:
				numbers.pop_back()
			else:
				numbers += range(numbers[-1] + 1, end_number)
			return numbers
		else:
			return []
	else:
		return range(start_number + 1, end_number)


static func get_numbers_by_skip_count(start_number: int, skip_count: int,
		bound_number: int = 100
) -> Array:
	var numbers := range(start_number, bound_number + 1, skip_count)
	numbers.remove_at(0)
	return numbers


static func get_numbers_in_direction(start_number: int, number_of_numbers: int,
		direction: String
) -> Array:
	var skip_count: int = {"right": 1, "down": 10} [direction]
	var bound_number := mini(start_number + number_of_numbers * skip_count, 100)
	return get_numbers_by_skip_count(start_number, skip_count, bound_number)


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
		var cell: GridCell = get_grid_cell(number)
		if is_cell_occupied(cell):
			number_sequence.append(number)
			number += 1
		else:
			return number_sequence
	return number_sequence


func get_highlighted_numbers() -> Array:
	var highlighted_cell := get_highlighted_grid_cell()
	if highlighted_cell != null:
		return [highlighted_cell.number]
	else:
		return []


func get_all_marked_numbers() -> Array:
	var marked_numbers: Array = []
	for cell in get_grid_cell_list():
		if is_cell_occupied(cell) or is_cell_highlighted(cell):
			marked_numbers.append(cell.number)
	return marked_numbers


func get_marked_numbers(cell_mark_type := GridCounting.CellMarks.ALL) -> Array:
	match cell_mark_type:
		GridCounting.CellMarks.UNIT:
			return get_numbers_with_units()
		GridCounting.CellMarks.HIGHLIGHT:
			return get_highlighted_numbers()
		GridCounting.CellMarks.ALL:
			return get_all_marked_numbers()
		_:
			assert(false)
			return []


func get_contiguous_number_sequences(cell_mark_type := GridCounting.CellMarks.ALL
) -> Array:
	var numbers := get_marked_numbers(cell_mark_type)
	var contiguous_number_sequences: Array = []
	var first_number: int = 0
	var last_number: int = 0
	var last_index: int = 0
	for index in numbers.size():
		if index == 0:
			first_number = numbers[index]
		elif numbers[index] == numbers[last_index] + 1:
			last_number = numbers[index]
		else:
			if last_number > first_number:
				contiguous_number_sequences.append([first_number, last_number])
			first_number = numbers[index]
		last_index = index
	if last_number > first_number:
		contiguous_number_sequences.append([first_number, last_number])
	return contiguous_number_sequences


func are_all_marks_contiguous(cell_mark_type := GridCounting.CellMarks.ALL) -> bool:
	var numbers := get_marked_numbers(cell_mark_type)
	if numbers.is_empty():
		return false

	var last_number: int = -1
	for number in numbers:
		if last_number != -1 and number != last_number + 1:
			return false
		last_number = number
	return true


func get_smallest_marked_number(cell_mark_type := GridCounting.CellMarks.ALL) -> int:
	var numbers := get_marked_numbers(cell_mark_type)
	if numbers.size() > 0:
		numbers.sort()
		return numbers[0]
	return -1


func get_biggest_marked_number(cell_mark_type := GridCounting.CellMarks.ALL) -> int:
	var numbers := get_marked_numbers(cell_mark_type)
	if numbers.size() > 0:
		numbers.sort()
		return numbers[-1]
	return -1


#endregion
#====================================================================
# Actions
#====================================================================
#region

#--------------------------------------
# Basic Actions
#--------------------------------------

func create_unit(grid_cell: GridCell) -> FieldObject:
	if not is_cell_occupied(grid_cell):
		var unit := GridCounting.ObjectUnit.instantiate() as FieldObject
		unit.number_changed.connect(_on_unit_number_changed.bind(unit))
		add_child(unit)
		unit.put_on_cell(grid_cell)
		return unit
	return null


func create_unit_by_number(number: int) -> FieldObject:
	var grid_cell = get_grid_cell(number)
	var new_unit := create_unit(grid_cell)
	return new_unit


func create_ten_block(row_number: int) -> FieldObject:
	var row_cells: Array = get_grid_cells_by_row(row_number)
	for cell in row_cells:
		if is_cell_occupied(cell):
			return null

	var ten_block := GridCounting.ObjectTenBlock.instantiate() as FieldObject
	add_child(ten_block)
	ten_block.put_on_row(row_number)
	return ten_block


func delete_unit(unit: FieldObject) -> void:
	unit.free()


func delete_unit_by_number(number: int) -> void:
	var unit = get_unit(number)
	unit.free()


func delete_block(block: FieldObject) -> void:
	block.free()


func move_unit(unit: FieldObject, cell: GridCell) -> void:
	unit.put_on_cell(cell)


func move_unit_by_numbers(from: int, to: int) -> void:
	var unit = get_unit(from)
	var grid_cell = get_grid_cell(to)
	assert(unit != null)
	assert(grid_cell != null)
	if from == to:
		return
	elif is_cell_occupied(grid_cell):
		delete_unit(unit)
	else:
		move_unit(unit, grid_cell)


func toggle_highlight(cell: GridCell) -> void:
	if not cell.highlighted:
		highlight_single_cell(cell)
	else:
		unhighlight_cells()


func highlight_single_cell(cell: GridCell) -> void:
	var previous_cell = get_highlighted_grid_cell()
	if previous_cell != null:
		previous_cell.toggle_highlight()
		cell.toggle_highlight()
	elif not cell.highlighted:
		cell.toggle_highlight()


func unhighlight_cells() -> void:
	var cell = get_highlighted_grid_cell()
	if cell != null:
		cell.toggle_highlight()


#--------------------------------------
# Effects
#--------------------------------------

func give_number_effect_by_grid_cell(cell: GridCell) -> NumberEffect:
	return math_effects.give_number(cell.number, cell.global_position, "grow")


func give_number_effect_by_number(number: int) -> NumberEffect:
	var grid_cell = get_grid_cell(number)
	return give_number_effect_by_grid_cell(grid_cell)


func count_unit(unit: FieldObject) -> NumberEffect:
	return effect_counter.count_next(unit.global_position)


func count_cell(number: int) -> NumberEffect:
	var cell = get_grid_cell(number)
	return effect_counter.count_next(cell.global_position)


func stage_unit_warning(unit: FieldObject) -> void:
	unit.set_variant("warning")
	warning_effects.stage_warning(unit.position)


func stage_ten_block_warning(ten_block: FieldObject) -> void:
	ten_block.set_variant("warning")
	warning_effects.stage_warning(ten_block.position)


func remove_unit_warning(unit: FieldObject) -> void:
	unit.set_variant("default")


func remove_ten_block_warning(ten_block: FieldObject) -> void:
	ten_block.set_variant("default")


#--------------------------------------
# Field-Setting
#--------------------------------------

func set_empty() -> void:
	for unit in get_unit_list():
		unit.free()
	for ten_block in get_ten_block_list():
		ten_block.free()

	unhighlight_cells()
	math_effects.clear()
	effect_counter.reset_count()


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
	for cell in get_grid_cell_list():
		data[cell.number] = {
			"highlighted": cell.highlighted,
			"has_unit": cell.has_unit(),
		}
	return data


func _get_rows_data() -> Dictionary:
	var data := {}
	for ten_block in get_ten_block_list():
		data[ten_block.row_number] = {
			"has_ten_block": true,
		}
	return data


#--------------------------------------
# State Loading
#--------------------------------------

func load_state(state: CRMemento) -> void:
	set_empty()

	_load_cell_data(state.data.cells)
	_load_row_data(state.data.rows)

	_trigger_update(UpdateTypes.STATE_LOADED)


func _load_cell_data(cell_data: Dictionary) -> void:
	for cell_number in cell_data.keys():
		var cell = get_grid_cell(cell_number)
		if cell_data[cell_number].highlighted:
			toggle_highlight(cell)
		if cell_data[cell_number].has_unit:
			create_unit(cell)


func _load_row_data(row_data: Dictionary) -> void:
	for row_number in row_data.keys():
		if row_data[row_number].has_ten_block:
			create_ten_block(row_number)


#endregion
