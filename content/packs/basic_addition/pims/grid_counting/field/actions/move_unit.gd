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

var from_cell_number: int
var to_cell_number: int
var unit: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.MOVE_UNIT


func _init(p_field: Field, p_from_cell_number: int, p_to_cell_number: int) -> void:
	super(p_field)
	from_cell_number = p_from_cell_number
	to_cell_number = p_to_cell_number


func is_valid() -> bool:
	return (
		from_cell_number >= 1 and from_cell_number <= 100
		and to_cell_number >= 1 and to_cell_number <= 100
		and from_cell_number != to_cell_number
	)


func is_possible() -> bool:
	return (
		field.dynamic_model.get_grid_cell(from_cell_number).has_unit()
		and not field.is_cell_occupied(field.dynamic_model.get_grid_cell(to_cell_number))
	)


func prefigure() -> void:
	if not is_valid() or not is_possible():
		field.clear_prefig()
		return

	field.prefigure_unit(to_cell_number)


func unprefigure() -> void:
	field.clear_prefig()


func do() -> void:
	unit = field.dynamic_model.get_unit(from_cell_number)
	unit.put_on_cell(to_cell_number)
