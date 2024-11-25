#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionDeleteTenBlock
extends FieldAction

var row_number: int


static func get_name() -> int:
	return GridCounting.Actions.DELETE_TEN_BLOCK


func _init(p_field: Field, p_row_number: int) -> void:
	super(p_field)
	row_number = p_row_number


func is_valid() -> bool:
	return row_number >= 1 and row_number <= 100


func is_possible() -> bool:
	return field.dynamic_model.get_ten_block(row_number) != null


func do() -> void:
	field.dynamic_model.get_ten_block(row_number).free()
