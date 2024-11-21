#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldObject

var row_number: int # Row numbers start at 1
var numbers: Array:
	get = _get_numbers
var first_number: int:
	get:
		return GridCounting.get_first_number_in_row(row_number)


static func _get_object_type() -> int:
	return GridCounting.Objects.TEN_BLOCK


func put_on_row(p_row_number: int) -> void:
	row_number = p_row_number
	var row_cells = field.get_grid_cells_by_row(row_number)
	var center_x = (row_cells[0].position.x
			+ (row_cells[9].position.x - row_cells[0].position.x) / 2)
	var center_y = row_cells[0].position.y
	position = Vector2(center_x, center_y)


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant


func _get_numbers() -> Array:
	return range(GridCounting.get_first_number_in_row(row_number),
			GridCounting.get_last_number_in_row(row_number) + 1)
