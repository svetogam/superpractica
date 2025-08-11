# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends AutoCountProgram

@export var zero_cell_number: int = 1


func _count_next(count: int) -> NumberSignal:
	var next_object = items[count]
	return field.count_signaler.count_object(next_object)


func _count_zero() -> NumberSignal:
	var zero_position = field.dynamic_model.get_grid_cell(zero_cell_number).position
	return field.info_signaler.popup_number(0, zero_position)
