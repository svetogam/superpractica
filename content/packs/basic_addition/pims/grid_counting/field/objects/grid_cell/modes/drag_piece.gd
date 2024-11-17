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


func _take_drop(dropped_object: FieldObject, point: Vector2) -> void:
	if not field.is_cell_occupied(object):
		match dropped_object.object_type:
			GridCounting.Objects.UNIT:
				field.push_action(field.create_unit.bind(object))
			GridCounting.Objects.TWO_BLOCK:
				var first_number = field.get_2_grid_cells_at_point(point)[0].number
				field.push_action(field.create_two_block.bind(first_number))
			GridCounting.Objects.TEN_BLOCK:
				var row_number = field.get_row_number_for_cell_number(object.number)
				field.push_action(field.create_ten_block.bind(row_number))
	get_viewport().set_input_as_handled()
