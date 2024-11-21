#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionMoveTenBlock
extends FieldAction

var from_row_number: int
var to_row_number: int


static func get_name() -> int:
	return GridCounting.Actions.MOVE_TEN_BLOCK


func _init(p_field: Field, p_from_row_number: int, p_to_row_number: int) -> void:
	super(p_field)
	from_row_number = p_from_row_number
	to_row_number = p_to_row_number


func is_valid() -> bool:
	return (
		from_row_number >= 1 and from_row_number <= 10
		and to_row_number >= 1 and to_row_number <= 10
		and from_row_number != to_row_number
	)


func is_possible() -> bool:
	if field.get_ten_block(from_row_number) == null:
		return false

	var row_cells: Array = field.get_grid_cells_by_row(to_row_number)
	return not row_cells.any(field.is_cell_occupied)


func do() -> void:
	var ten_block = field.get_ten_block(from_row_number)
	ten_block.put_on_row(to_row_number)
