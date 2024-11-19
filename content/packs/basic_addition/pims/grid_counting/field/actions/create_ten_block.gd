#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionCreateTenBlock
extends FieldAction

var row_number: int = -1


static func get_name() -> int:
	return GridCounting.Actions.CREATE_TEN_BLOCK


func setup(p_row_number: int) -> FieldAction:
	row_number = p_row_number
	return self


func is_valid() -> bool:
	if row_number == -1:
		return false
	return true


func do() -> void:
	var row_cells: Array = field.get_grid_cells_by_row(row_number)
	for cell in row_cells:
		if field.is_cell_occupied(cell):
			return

	var ten_block := GridCounting.ObjectTenBlock.instantiate() as FieldObject
	field.add_child(ten_block)
	ten_block.put_on_row(row_number)
