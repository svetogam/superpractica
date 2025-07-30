# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObject

var first_number: int
var numbers: Array:
	get:
		return [first_number, first_number + 1, first_number + 2, first_number + 3]
var cells: Array:
	get:
		return [
			field.dynamic_model.get_grid_cell(first_number),
			field.dynamic_model.get_grid_cell(first_number + 1),
			field.dynamic_model.get_grid_cell(first_number + 2),
			field.dynamic_model.get_grid_cell(first_number + 3),
		]


static func _get_object_type() -> int:
	return GridCounting.Objects.FOUR_BLOCK


# p_first_number is the first cell the block occupies
func put_on_grid(p_first_number: int) -> void:
	assert(p_first_number % 10 != 0)
	assert(p_first_number % 10 != 9)
	assert(p_first_number % 10 != 8)

	first_number = p_first_number
	position = Vector2(
		cells[0].position.x + (cells[3].position.x - cells[0].position.x) / 2,
		cells[0].position.y
	)


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant
