# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionMoveTwentyBlock
extends FieldAction

var from_first_row_number: int
var to_first_row_number: int
var block: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.MOVE_TWENTY_BLOCK


func _init(p_field: Field, p_from_first_row_number: int, p_to_first_row_number: int
) -> void:
	super(p_field)
	from_first_row_number = p_from_first_row_number
	to_first_row_number = p_to_first_row_number


func is_valid() -> bool:
	return (
		from_first_row_number >= 1 and from_first_row_number <= 9
		and to_first_row_number >= 1 and to_first_row_number <= 9
		and from_first_row_number != to_first_row_number
	)


func is_possible() -> bool:
	if field.dynamic_model.get_twenty_block(from_first_row_number) == null:
		return false

	var needed_row_numbers: Array = [
		to_first_row_number,
		to_first_row_number + 1,
	]
	needed_row_numbers.erase(from_first_row_number)
	needed_row_numbers.erase(from_first_row_number + 1)
	var cells: Array = field.get_grid_cells_by_rows(needed_row_numbers)
	return not cells.any(field.is_cell_occupied)


func prefigure() -> void:
	if is_valid() and is_possible():
		field.prefigure_twenty_block(to_first_row_number)
	else:
		field.prefigure_twenty_block(from_first_row_number)


func unprefigure() -> void:
	field.clear_prefig()


func do() -> void:
	block = field.dynamic_model.get_twenty_block(from_first_row_number)
	block.put_on_row(to_first_row_number)
