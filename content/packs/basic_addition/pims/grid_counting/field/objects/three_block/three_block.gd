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

var first_number: int
var numbers: Array:
	get:
		return [first_number, first_number + 1, first_number + 2]
var cells: Array:
	get:
		return [
			field.dynamic_model.get_grid_cell(first_number),
			field.dynamic_model.get_grid_cell(first_number + 1),
			field.dynamic_model.get_grid_cell(first_number + 2),
		]


static func _get_object_type() -> int:
	return GridCounting.Objects.THREE_BLOCK


# p_first_number is the first cell the block occupies
func put_on_grid(p_first_number: int) -> void:
	assert(p_first_number % 10 != 0)
	assert(p_first_number % 10 != 9)

	first_number = p_first_number
	position = Vector2(
		cells[1].position.x,
		cells[0].position.y
	)


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant
