# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObject

var row_number: int # Row numbers start at 1
var numbers: Array:
	get = _get_numbers
var first_number: int:
	get:
		return field.static_model.get_first_cell_in_row(row_number)


static func _get_object_type() -> String:
	return GridCounting.OBJECT_TEN_BLOCK


func put_on_row(p_row_number: int) -> void:
	assert(p_row_number >= 1 and p_row_number <= 10)

	row_number = p_row_number
	var cells = field.get_grid_cells_by_rows([row_number])
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
