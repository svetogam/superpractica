# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionDeleteUnit
extends FieldAction

var cell_number: int


static func get_name() -> int:
	return GridCounting.Actions.DELETE_UNIT


func _init(p_field: Field, p_cell_number: int) -> void:
	super(p_field)
	cell_number = p_cell_number


func is_valid() -> bool:
	return cell_number >= 1 and cell_number <= 100


func is_possible() -> bool:
	return field.dynamic_model.get_unit(cell_number) != null


func do() -> void:
	field.dynamic_model.get_unit(cell_number).free()
