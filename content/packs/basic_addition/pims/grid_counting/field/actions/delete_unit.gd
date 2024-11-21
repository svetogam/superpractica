#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionDeleteUnit
extends FieldAction

var unit_cell_number: int


static func get_name() -> int:
	return GridCounting.Actions.DELETE_UNIT


func _init(p_field: Field, p_unit_cell_number: int) -> void:
	super(p_field)
	unit_cell_number = p_unit_cell_number


func is_valid() -> bool:
	return unit_cell_number >= 1 and unit_cell_number <= 100


func is_possible() -> bool:
	return field.get_unit(unit_cell_number) != null


func do() -> void:
	field.get_unit(unit_cell_number).free()
