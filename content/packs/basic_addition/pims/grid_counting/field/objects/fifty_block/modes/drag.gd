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


func _dropped(_external: bool, point: Vector2) -> void:
	var dest_cell = field.get_grid_cell_at_point(point)
	var dest_row = field.static_model.get_row_of_cell(dest_cell.number) - 2
	GridCountingActionMoveFiftyBlock.new(field, object.first_row_number, dest_row).push()


func _dropped_out(_receiver: Field) -> void:
	GridCountingActionDeleteFiftyBlock.new(field, object.first_row_number).push()
