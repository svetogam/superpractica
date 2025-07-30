# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObjectMode

var drop_action: FieldAction


func _pressed(_point: Vector2) -> void:
	object.grab(true)


func _dragged(_external: bool, point: Vector2, _change: Vector2) -> void:
	var dest_cell = field.get_grid_cell_at_point(point)
	if dest_cell != null:
		var dest_row = field.static_model.get_row_of_cell(dest_cell.number) - 1
		drop_action = GridCountingActionMoveThirtyBlock.new(
				field, object.first_row_number, dest_row)
		drop_action.prefigure()
	elif drop_action != null:
		drop_action.unprefigure()


func _dropped(_external: bool, _point: Vector2) -> void:
	assert(drop_action != null)
	drop_action.push()


func _dropped_out(_receiver: Field) -> void:
	GridCountingActionDeleteThirtyBlock.new(field, object.first_row_number).push()
