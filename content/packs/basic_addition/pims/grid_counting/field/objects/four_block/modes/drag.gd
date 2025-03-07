# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObjectMode

var drop_action: FieldAction


func _pressed(_point: Vector2) -> void:
	object.grab(true)


func _dragged(_external: bool, point: Vector2, _change: Vector2) -> void:
	var dest_cells = field.get_h_adjacent_grid_cells_at_point(point)
	if not dest_cells.is_empty():
		drop_action = GridCountingActionMoveFourBlock.new(
				field, object.first_number, dest_cells[0].number - 1)
		drop_action.prefigure()
	elif drop_action != null:
		drop_action.unprefigure()


func _dropped(_external: bool, _point: Vector2) -> void:
	assert(drop_action != null)
	drop_action.push()


func _dropped_out(_receiver: Field) -> void:
	GridCountingActionDeleteFourBlock.new(field, object.first_number).push()
