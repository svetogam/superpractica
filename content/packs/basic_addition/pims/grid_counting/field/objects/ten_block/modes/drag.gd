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


func _pressed(_point: Vector2) -> void:
	object.grab(true)


func _dropped(external: bool, point: Vector2) -> void:
	if external:
		var dest_cell = field.get_grid_cell_at_point(point)
		var dest_row = field.get_row_number_for_cell_number(dest_cell.number)
		if object.row_number != dest_row and not field.is_row_occupied(dest_row):
			GridCountingActionDeleteBlock.new(field, object.first_number).push()


func _dropped_out(_receiver: Field) -> void:
	GridCountingActionDeleteBlock.new(field, object.first_number).push()
