# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionCreateTwentyBlock
extends FieldAction

var first_row_number: int
var block: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.CREATE_TWENTY_BLOCK


func _init(p_field: Field, p_first_row_number: int) -> void:
	super(p_field)
	first_row_number = p_first_row_number


func is_valid() -> bool:
	return first_row_number >= 1 and first_row_number <= 9


func is_possible() -> bool:
	var row_cells: Array = field.get_grid_cells_by_rows([
		first_row_number,
		first_row_number + 1,
	])
	return not row_cells.any(field.is_cell_occupied)


func prefigure() -> void:
	if not is_valid() or not is_possible():
		field.clear_prefig()
		return

	field.prefigure_twenty_block(first_row_number)


func unprefigure() -> void:
	field.clear_prefig()


func do() -> void:
	block = GridCounting.ObjectTwentyBlock.instantiate() as FieldObject
	field.add_child(block)
	block.put_on_row(first_row_number)
