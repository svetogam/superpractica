# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingActionToggleMark
extends FieldAction

var cell_number: int


static func get_name() -> int:
	return GridCounting.Actions.TOGGLE_MARK


func _init(p_field: Field, p_cell_number: int) -> void:
	super(p_field)
	cell_number = p_cell_number


func is_valid() -> bool:
	return cell_number >= 1 and cell_number <= 100


func do() -> void:
	var marked_cell = field.get_marked_cell()
	if marked_cell != null and marked_cell.number != cell_number:
		marked_cell.toggle_mark()
	var new_cell = field.dynamic_model.get_grid_cell(cell_number)
	new_cell.toggle_mark()
