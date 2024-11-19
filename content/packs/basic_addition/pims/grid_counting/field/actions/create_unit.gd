#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldAction

var grid_cell: GridCell


static func get_name() -> String:
	return "create_unit"


func setup(p_grid_cell: GridCell) -> FieldAction:
	grid_cell = p_grid_cell
	return self


func is_valid() -> bool:
	if grid_cell == null:
		return false
	return true


func do() -> void:
	if not field.is_cell_occupied(grid_cell):
		var unit := GridCounting.ObjectUnit.instantiate() as FieldObject
		unit.number_changed.connect(field._on_unit_number_changed.bind(unit))
		field.add_child(unit)
		unit.put_on_cell(grid_cell)
