# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionMoveFourBlock
extends FieldAction

var from_first_number: int
var to_first_number: int
var block: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.MOVE_FOUR_BLOCK


func _init(p_field: Field, p_from_first_number: int, p_to_first_number: int) -> void:
	super(p_field)
	from_first_number = p_from_first_number
	to_first_number = p_to_first_number


func is_valid() -> bool:
	return (
		from_first_number >= 1 and from_first_number <= 100
		and to_first_number >= 1 and to_first_number <= 100
		and from_first_number % 10 != 0
		and to_first_number % 10 != 0
		and from_first_number % 10 != 9
		and to_first_number % 10 != 9
		and from_first_number % 10 != 8
		and to_first_number % 10 != 8
		and from_first_number != to_first_number
	)


func is_possible() -> bool:
	if field.dynamic_model.get_four_block(from_first_number) == null:
		return false

	var needed_cell_numbers: Array = [
		to_first_number,
		to_first_number + 1,
		to_first_number + 2,
		to_first_number + 3,
	]
	needed_cell_numbers.erase(from_first_number)
	needed_cell_numbers.erase(from_first_number + 1)
	needed_cell_numbers.erase(from_first_number + 2)
	needed_cell_numbers.erase(from_first_number + 3)
	var cells: Array = field.get_grid_cells_by_numbers(needed_cell_numbers)
	return not cells.any(field.is_cell_occupied)


func prefigure() -> void:
	if is_valid() and is_possible():
		field.prefigure_four_block(to_first_number)
	else:
		field.prefigure_four_block(from_first_number)


func unprefigure() -> void:
	field.clear_prefig()


func do() -> void:
	block = field.dynamic_model.get_four_block(from_first_number)
	block.put_on_grid(to_first_number)
