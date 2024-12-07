#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldObjectMode

var drop_action: FieldAction


func _pressed(_point: Vector2) -> void:
	object.grab(true)


func _dragged(_external: bool, point: Vector2, _change: Vector2) -> void:
	var dest_cells = field.get_v_adjacent_grid_cells_at_point(point)
	if not dest_cells.is_empty():
		var dest_row = field.static_model.get_row_of_cell(dest_cells[0].number)
		drop_action = GridCountingActionMoveTwentyBlock.new(
				field, object.first_row_number, dest_row)
		drop_action.prefigure()


func _dropped(_external: bool, _point: Vector2) -> void:
	assert(drop_action != null)
	drop_action.push()


func _dropped_out(_receiver: Field) -> void:
	GridCountingActionDeleteTwentyBlock.new(field, object.first_row_number).push()
