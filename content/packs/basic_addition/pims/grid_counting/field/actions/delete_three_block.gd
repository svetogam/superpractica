# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionDeleteThreeBlock
extends FieldAction

var first_number: int


static func get_name() -> int:
	return GridCounting.Actions.DELETE_THREE_BLOCK


func _init(p_field: Field, p_first_number: int) -> void:
	super(p_field)
	first_number = p_first_number


func is_valid() -> bool:
	return (
		first_number >= 1
		and first_number <= 100
		and first_number % 10 != 0
		and first_number % 10 != 9
	)


func is_possible() -> bool:
	return field.dynamic_model.get_three_block(first_number) != null


func do() -> void:
	field.dynamic_model.get_three_block(first_number).free()
