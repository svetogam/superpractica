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
		var dest_cells = field.get_2_grid_cells_at_point(point)
		if (not dest_cells.any(field.is_cell_occupied)
				and object.first_number != dest_cells[0].number):
			GridCountingActionDeleteBlock.new(field, object.first_number).push()


func _dropped_out(_receiver: Field) -> void:
	GridCountingActionDeleteBlock.new(field, object.first_number).push()
