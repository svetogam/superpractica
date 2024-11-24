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

var row_number: int = -1 # Row numbers start at 1
var numbers: Array:
	get = _get_numbers
var first_number: int:
	get:
		return field.static_model.get_first_cell_in_row(row_number)


static func _get_object_type() -> int:
	return GridCounting.Objects.TEN_BLOCK


func _exit_tree() -> void:
	field.dynamic_model.unset_ten_block(row_number, self)


func put_on_row(p_row_number: int) -> void:
	assert(p_row_number >= 1 and p_row_number <= 100)

	if row_number != -1:
		field.dynamic_model.unset_ten_block(row_number, self)
	field.dynamic_model.set_ten_block(p_row_number, self)

	row_number = p_row_number

	var cells = field.get_grid_cells_by_row(row_number)
	position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[0].position.y
	)


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant


func _get_numbers() -> Array:
	return range(field.static_model.get_first_cell_in_row(row_number),
			field.static_model.get_last_cell_in_row(row_number) + 1)
