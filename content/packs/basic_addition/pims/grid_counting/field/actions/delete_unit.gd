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

var unit: FieldObject


static func get_name() -> int:
	return GridCounting.Actions.DELETE_UNIT


func setup(p_unit: FieldObject) -> FieldAction:
	unit = p_unit
	return self


func is_valid() -> bool:
	if unit == null:
		return false
	return true


func do() -> void:
	unit.free()
