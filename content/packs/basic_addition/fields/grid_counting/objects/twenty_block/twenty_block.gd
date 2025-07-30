# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends FieldObject

var first_row_number: int # Row numbers start at 1
var row_numbers: Array:
	get:
		return [first_row_number, first_row_number + 1]
var numbers: Array:
	get = _get_numbers
var first_number: int:
	get:
		return field.static_model.get_first_cell_in_row(first_row_number)


static func _get_object_type() -> int:
	return GridCounting.Objects.TWENTY_BLOCK


func put_on_row(p_first_row_number: int) -> void:
	assert(p_first_row_number >= 1 and p_first_row_number <= 9)

	first_row_number = p_first_row_number
	var cells = field.get_grid_cells_by_rows(row_numbers)
	position = Vector2(
		cells[0].position.x + (cells[9].position.x - cells[0].position.x) / 2,
		cells[0].position.y + (cells[10].position.y - cells[0].position.y) / 2
	)


func set_variant(variant: StringName) -> void:
	assert(%Sprite.sprite_frames.has_animation(variant))
	%Sprite.animation = variant


func _get_numbers() -> Array:
	return range(field.static_model.get_first_cell_in_row(first_row_number),
			field.static_model.get_last_cell_in_row(first_row_number + 1) + 1)
