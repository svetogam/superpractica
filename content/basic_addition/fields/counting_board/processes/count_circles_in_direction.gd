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
var _direction: String


func _init(p_start_number: int, p_direction: String) -> void:
	_start_number = p_start_number
	_direction = p_direction


func _ready() -> void:
	var numbers_to_count = field.get_circled_numbers_in_direction(
			_start_number, _direction)
	if numbers_to_count.is_empty():
		var first_number: int = _start_number + {"right": 1, "down": 10} [_direction]
		CountingBoard.ProcessEmptyCountSquare.new(first_number).run(self, complete)
	else:
		var squares_to_count = field.get_number_squares_by_numbers(numbers_to_count)
		CountingBoard.ProcessCountSquares.new(squares_to_count).run(self, complete)
