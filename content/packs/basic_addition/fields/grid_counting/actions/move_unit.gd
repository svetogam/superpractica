# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionMoveUnit
extends FieldAction

var from_cell_number: int
var to_cell_number: int
var unit: FieldObject


static func get_name() -> String:
	return GridCounting.ACTION_MOVE_UNIT


func _init(p_field: Field, p_from_cell_number: int, p_to_cell_number: int) -> void:
	super(p_field)
	from_cell_number = p_from_cell_number
	to_cell_number = p_to_cell_number


func is_valid() -> bool:
	return (
		from_cell_number >= 1 and from_cell_number <= 100
		and to_cell_number >= 1 and to_cell_number <= 100
		and from_cell_number != to_cell_number
	)


func is_possible() -> bool:
	return (
		field.dynamic_model.get_grid_cell(from_cell_number).has_unit()
		and not field.is_cell_occupied(field.dynamic_model.get_grid_cell(to_cell_number))
	)


func prefigure() -> void:
	if is_valid() and is_possible():
		field.prefigure_unit(to_cell_number)
	else:
		field.prefigure_unit(from_cell_number)


func unprefigure() -> void:
	field.clear_prefig()


func do() -> void:
	unit = field.dynamic_model.get_unit(from_cell_number)
	unit.put_on_cell(to_cell_number)
