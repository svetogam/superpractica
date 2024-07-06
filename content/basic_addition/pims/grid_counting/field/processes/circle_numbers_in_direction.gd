#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldProcess

var _start_number: int
var _number_circles: int
var _direction: String
var _show_count: bool
var _cells_to_count: Array
var _count := 0


func _init(p_start_number: int, p_count: int, p_direction: String, p_show_count := true
) -> void:
	_start_number = p_start_number
	_number_circles = p_count
	_direction = p_direction
	_show_count = p_show_count


func _ready() -> void:
	var numbers_to_count = field.get_numbers_in_direction(
			_start_number, _number_circles, _direction)
	for number in numbers_to_count:
		_cells_to_count.append(field.get_grid_cell(number))

	_circle_next_number()


func _circle_next_number() -> void:
	var next_cell = _cells_to_count[_count]
	field.toggle_circle(next_cell)

	await Game.wait_for(0.5)

	if _show_count:
		field.count_cell(next_cell.number)
		await Game.wait_for(0.5)

	_count += 1
	if _count == _cells_to_count.size():
		complete(_count)
	else:
		_circle_next_number()


func _exit_tree() -> void:
	if _show_count:
		field.effect_counter.reset_count()
