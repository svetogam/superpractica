#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionCreateUnit
extends FieldAction

var cell_number: int


static func get_name() -> int:
	return GridCounting.Actions.CREATE_UNIT


func _init(p_field: Field, p_cell_number: int) -> void:
	super(p_field)
	cell_number = p_cell_number


func is_valid() -> bool:
	return cell_number >= 1 and cell_number <= 100


func is_possible() -> bool:
	var cell = field.get_grid_cell(cell_number)
	return not field.is_cell_occupied(cell)


func do() -> void:
	var unit := GridCounting.ObjectUnit.instantiate() as FieldObject
	unit.number_changed.connect(field._on_unit_number_changed.bind(unit))
	field.add_child(unit)
	var cell = field.get_grid_cell(cell_number)
	unit.put_on_cell(cell)
