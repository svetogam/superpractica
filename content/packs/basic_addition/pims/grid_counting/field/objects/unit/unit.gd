# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

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
