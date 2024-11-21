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

var unit: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.DELETE_UNIT


func _init(p_field: Field, p_unit: FieldObject) -> void:
	super(p_field)
	unit = p_unit


func is_valid() -> bool:
	if unit == null:
		return false
	return true


func do() -> void:
	unit.free()
