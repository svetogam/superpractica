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

var grid_cells: Array = []
var numbers: Array:
	get:
		assert(grid_cells.size() == 2)
		return [grid_cells[0].number, grid_cells[1].number]
var first_number: int:
	get:
		assert(grid_cells.size() == 2)
		return grid_cells[0].number


static func _get_object_type() -> int:
	return GridCounting.Objects.TWO_BLOCK


func put_on_cells(p_grid_cells: Array) -> void:
	assert(p_grid_cells.size() == 2)

	grid_cells = p_grid_cells
	var center_x = (grid_cells[0].position.x
			+ (grid_cells[1].position.x - grid_cells[0].position.x) / 2)
	var center_y = grid_cells[0].position.y
	position = Vector2(center_x, center_y)


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant
