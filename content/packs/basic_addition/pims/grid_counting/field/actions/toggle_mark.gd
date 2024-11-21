#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionToggleMark
extends FieldAction

var cell_number: int


static func get_name() -> int:
	return GridCounting.Actions.TOGGLE_MARK


func _init(p_field: Field, p_cell_number: int) -> void:
	super(p_field)
	cell_number = p_cell_number


func is_valid() -> bool:
	return cell_number >= 1 and cell_number <= 100


func do() -> void:
	var marked_cell = field.get_marked_cell()
	if marked_cell != null and marked_cell.number != cell_number:
		marked_cell.toggle_mark()
	var new_cell = field.get_grid_cell(cell_number)
	new_cell.toggle_mark()
