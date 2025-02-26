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

var cell_number: int
var cell: GridCell:
	get:
		return field.dynamic_model.get_grid_cell(cell_number)


static func _get_object_type() -> int:
	return GridCounting.Objects.UNIT


func put_on_cell(p_cell_number: int) -> void:
	cell_number = p_cell_number
	position = cell.position


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant
