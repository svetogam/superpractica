#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends SoftLimiterProgram

@export var _start_number: int
@export var _addend: int


func setup(p_start_number: int, p_addend: int) -> void:
	assert(not is_running())

	_start_number = p_start_number
	_addend = p_addend


func _give_warnings() -> Array:
	var warning_positions: Array = []

	for square in field.get_circled_number_squares():
		if _is_circle_valid(square.number):
			square.set_circle_variant("normal")
		else:
			square.set_circle_variant("warning")
			warning_positions.append(square.position)

	return warning_positions


func _is_circle_valid(check_number: int) -> bool:
	for number in _get_correct_numbers():
		var square = field.get_number_square(number)
		if square.circled:
			if check_number == number:
				return true
		else:
			return false
	return false


func _get_correct_numbers() -> Array:
	var correct_numbers: Array = []
	var target_number: int = _start_number + _addend
	correct_numbers += field.get_numbers_between(_start_number, target_number, true)
	correct_numbers.append(target_number)
	return correct_numbers


func is_valid() -> bool:
	for number in field.get_circled_numbers():
		if not _is_circle_valid(number):
			return false
	return true
