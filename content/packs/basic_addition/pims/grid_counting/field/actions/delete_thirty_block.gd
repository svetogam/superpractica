#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingActionDeleteThirtyBlock
extends FieldAction

var first_row_number: int


static func get_name() -> int:
	return GridCounting.Actions.DELETE_THIRTY_BLOCK


func _init(p_field: Field, p_first_row_number: int) -> void:
	super(p_field)
	first_row_number = p_first_row_number


func is_valid() -> bool:
	return first_row_number >= 1 and first_row_number <= 8


func is_possible() -> bool:
	return field.dynamic_model.get_thirty_block(first_row_number) != null


func do() -> void:
	field.dynamic_model.get_thirty_block(first_row_number).free()