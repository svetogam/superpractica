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

var _start_number: int


func setup(p_start_number: int) -> void:
	assert(not is_running())

	_start_number = p_start_number


func _give_warnings() -> Array:
	var warning_positions: Array = []

	for counter in field.get_counter_list():
		if _is_counter_valid(counter):
			counter.set_warning(false)
		else:
			counter.set_warning(true)
			warning_positions.append(counter.position)

	return warning_positions


func _is_counter_valid(counter: FieldObject) -> bool:
	var correct_numbers = field.get_contiguous_numbers_with_counters_from(
			_start_number + 1)
	return correct_numbers.has(counter.get_number())


func is_valid() -> bool:
	for counter in field.get_counter_list():
		if not _is_counter_valid(counter):
			return false
	return true
