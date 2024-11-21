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

var unit: FieldObject
var dest_cell: GridCell


static func get_name() -> int:
	return GridCounting.Actions.MOVE_UNIT


func _init(p_field: Field, p_unit: FieldObject, p_dest_cell: GridCell) -> void:
	super(p_field)
	unit = p_unit
	dest_cell = p_dest_cell


func is_valid() -> bool:
	if dest_cell == null or unit == null:
		return false
	return true


func is_possible() -> bool:
	return (
		is_valid()
		and unit.cell.number != dest_cell.number
		and not field.is_cell_occupied(dest_cell)
	)


func do() -> void:
	unit.put_on_cell(dest_cell)
