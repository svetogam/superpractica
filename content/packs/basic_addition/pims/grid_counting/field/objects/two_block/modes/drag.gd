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


func _press(_point: Vector2) -> void:
	field.request_drag_object(object)


func _drop(point: Vector2) -> void:
	var dest_cells = field.get_2_grid_cells_at_point(point)
	if (not dest_cells.any(field.is_cell_occupied)
			and object.first_number != dest_cells[0].number):
		GridCounting.ActionDeleteBlock.new(field).setup(object).push()
