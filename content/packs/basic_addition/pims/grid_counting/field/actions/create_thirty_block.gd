#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionCreateThirtyBlock
extends FieldAction

var first_row_number: int
var block: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.CREATE_THIRTY_BLOCK


func _init(p_field: Field, p_first_row_number: int) -> void:
	super(p_field)
	first_row_number = p_first_row_number


func is_valid() -> bool:
	return first_row_number >= 1 and first_row_number <= 8


func is_possible() -> bool:
	var row_cells: Array = field.get_grid_cells_by_rows([
		first_row_number,
		first_row_number + 1,
		first_row_number + 2,
	])
	return not row_cells.any(field.is_cell_occupied)


func do() -> void:
	block = GridCounting.ObjectThirtyBlock.instantiate() as FieldObject
	field.add_child(block)
	block.put_on_row(first_row_number)
