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

var row_number: int
var block: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.CREATE_TEN_BLOCK


func _init(p_field: Field, p_row_number: int) -> void:
	super(p_field)
	row_number = p_row_number


func is_valid() -> bool:
	return row_number >= 1 and row_number <= 10


func is_possible() -> bool:
	var row_cells: Array = field.get_grid_cells_by_rows([row_number])
	return not row_cells.any(field.is_cell_occupied)


func prefigure() -> void:
	if not is_valid() or not is_possible():
		field.clear_prefig()
		return

	field.prefigure_ten_block(row_number)


func unprefigure() -> void:
	field.clear_prefig()


func do() -> void:
	block = GridCounting.ObjectTenBlock.instantiate() as FieldObject
	field.add_child(block)
	block.put_on_row(row_number)
