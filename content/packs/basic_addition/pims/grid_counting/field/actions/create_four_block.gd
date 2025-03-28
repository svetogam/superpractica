# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionCreateFourBlock
extends FieldAction

var first_number: int
var block: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.CREATE_FOUR_BLOCK


func _init(p_field: Field, p_first_number: int) -> void:
	super(p_field)
	first_number = p_first_number


func is_valid() -> bool:
	return (
		first_number >= 1
		and first_number <= 100
		and first_number % 10 != 0
		and first_number % 10 != 9
		and first_number % 10 != 8
	)


func is_possible() -> bool:
	var cells: Array = field.get_grid_cells_by_numbers([first_number, first_number + 1,
			first_number + 2, first_number + 3])
	return not cells.any(field.is_cell_occupied)


func prefigure() -> void:
	if not is_valid() or not is_possible():
		field.clear_prefig()
		return

	field.prefigure_four_block(first_number)


func unprefigure() -> void:
	field.clear_prefig()


func do() -> void:
	block = GridCounting.ObjectFourBlock.instantiate() as FieldObject
	field.add_child(block)
	block.put_on_grid(first_number)
