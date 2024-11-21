#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionMoveUnit
extends FieldAction

var unit_cell_number: int
var to_cell_number: int


static func get_name() -> int:
	return GridCounting.Actions.MOVE_UNIT


func _init(p_field: Field, p_unit_cell_number: int, p_to_cell_number: int) -> void:
	super(p_field)
	unit_cell_number = p_unit_cell_number
	to_cell_number = p_to_cell_number


func is_valid() -> bool:
	return (
		unit_cell_number >= 1 and unit_cell_number <= 100
		and to_cell_number >= 1 and to_cell_number <= 100
		and unit_cell_number != to_cell_number
	)


func is_possible() -> bool:
	return (
		field.get_grid_cell(unit_cell_number).has_unit()
		and not field.is_cell_occupied(field.get_grid_cell(to_cell_number))
	)


func do() -> void:
	var unit = field.get_unit(unit_cell_number)
	var dest_cell = field.get_grid_cell(to_cell_number)
	unit.put_on_cell(dest_cell)
