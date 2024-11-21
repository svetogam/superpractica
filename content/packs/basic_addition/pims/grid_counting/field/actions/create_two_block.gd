#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionCreateTwoBlock
extends FieldAction

var first_number: int = -1


static func get_name() -> int:
	return GridCounting.Actions.CREATE_TWO_BLOCK


func _init(p_field: Field, p_first_number: int) -> void:
	super(p_field)
	first_number = p_first_number


func is_valid() -> bool:
	if first_number == -1:
		return false
	return true


func do() -> void:
	if first_number % 10 == 0:
		first_number -= 1
	var cells = field.get_grid_cells_by_numbers([first_number, first_number + 1])
	for cell in cells:
		if field.is_cell_occupied(cell):
			return

	var two_block := GridCounting.ObjectTwoBlock.instantiate() as FieldObject
	field.add_child(two_block)
	two_block.put_on_cells(cells)
