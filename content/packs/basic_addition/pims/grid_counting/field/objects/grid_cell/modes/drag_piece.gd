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


func _received(external: bool, dropped_object: FieldObject, _point: Vector2) -> void:
	if external:
		if not field.is_cell_occupied(object):
			match dropped_object.object_type:
				GridCounting.Objects.TEN_BLOCK:
					var row_number = field.get_row_number_for_cell_number(object.number)
					GridCountingActionCreateTenBlock.new(field, row_number).push()
		get_viewport().set_input_as_handled()
