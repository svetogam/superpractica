# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionDeleteFiftyBlock
extends FieldAction

var first_row_number: int


static func get_name() -> int:
	return GridCounting.Actions.DELETE_FIFTY_BLOCK


func _init(p_field: Field, p_first_row_number: int) -> void:
	super(p_field)
	first_row_number = p_first_row_number


func is_valid() -> bool:
	return first_row_number >= 1 and first_row_number <= 6


func is_possible() -> bool:
	return field.dynamic_model.get_fifty_block(first_row_number) != null


func do() -> void:
	field.dynamic_model.get_fifty_block(first_row_number).free()
