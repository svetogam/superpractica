##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldInterfaceComponent

#####################################################################
# Object-Finding
#####################################################################

func get_number_square_list() -> Array:
	return _field.get_object_list_by_type(CountingBoardGlobals.Objects.NUMBER_SQUARE)


func get_counter_list() -> Array:
	return _field.get_object_list_by_type(CountingBoardGlobals.Objects.COUNTER)


func get_number_square_at_point(point: Vector2) -> NumberSquare:
	var number_squares = get_number_square_list()
	for number_square in number_squares:
		if number_square.has_point(point):
			return number_square
	return null


func get_number_square(number: int) -> NumberSquare:
	var number_squares = get_number_square_list()
	for number_square in number_squares:
		if number_square.number == number:
			return number_square
	return null


func get_number_squares_by_numbers(number_list: Array) -> Array:
	var number_squares = []
	for number in number_list:
		var number_square = get_number_square(number)
		number_squares.append(number_square)
	return number_squares


func get_highlighted_number_square() -> NumberSquare:
	for square in get_number_square_list():
		if square.highlighted:
			return square
	return null


func is_any_square_highlighted() -> bool:
	return get_highlighted_number_square() != null


func get_circled_number_squares() -> Array:
	var circled_squares = []
	var squares = get_number_square_list()
	for square in squares:
		if square.circled:
			circled_squares.append(square)
	return circled_squares


func get_number_squares_with_counters() -> Array:
	var squares = []
	var counters = get_counter_list()
	for counter in counters:
		if not squares.has(counter.square):
			squares.append(counter.square)
	return squares


func get_counter_on_square(number_square: NumberSquare) -> FieldObject:
	for counter in get_counter_list():
		if counter.square.name == number_square.name:
			return counter
	return null


func get_counter_by_number(number: int) -> FieldObject:
	var number_square = get_number_square(number)
	return get_counter_on_square(number_square)


#####################################################################
# Analysis
#####################################################################

func get_circled_numbers() -> Array:
	var numbers = []
	var squares = get_circled_number_squares()
	for square in squares:
		numbers.append(square.number)
	numbers.sort()
	return numbers


func is_number_circled(number: int) -> bool:
	return get_circled_numbers().has(number)


func get_numbers_with_counters() -> Array:
	var numbers = []
	var squares = get_number_squares_with_counters()
	for square in squares:
		numbers.append(square.number)
	numbers.sort()
	return numbers


func does_number_have_counter(number: int) -> bool:
	return get_numbers_with_counters().has(number)


func get_numbers_between(start_number: int, end_number: int, skip_count_tens: bool) -> Array:
	if skip_count_tens and end_number >= start_number + 10:
		var numbers = []
		numbers += get_numbers_by_skip_count(start_number, 10, end_number)
		if numbers[-1] == end_number:
			numbers.pop_back()
		else:
			numbers += range(numbers[-1] + 1, end_number)
		return numbers
	else:
		return range(start_number + 1, end_number)


func get_numbers_by_skip_count(start_number: int, skip_count: int, bound_number:=100) -> Array:
	var numbers = range(start_number, bound_number + 1, skip_count)
	numbers.remove_at(0)
	return numbers


func get_numbers_in_direction(start_number: int, number_of_numbers: int,
			direction: String) -> Array:
	var skip_count = {"right": 1, "down": 10} [direction]
	var bound_number = start_number + number_of_numbers * skip_count
	return get_numbers_by_skip_count(start_number, skip_count, bound_number)


func get_circled_numbers_by_skip_count(start_number: int, skip_count: int,
			bound_number:=100) -> Array:
	var counted_numbers = get_numbers_by_skip_count(start_number, skip_count, bound_number)
	var circled_numbers = []
	for number in counted_numbers:
		var square = get_number_square(number)
		if square.circled:
			circled_numbers.append(number)
		else:
			return circled_numbers
	return circled_numbers


func get_circled_numbers_in_direction(start_number: int, direction: String) -> Array:
	var skip_count = {"right": 1, "down": 10} [direction]
	return get_circled_numbers_by_skip_count(start_number, skip_count)


func get_contiguous_numbers_with_counters_from(first_number: int) -> Array:
	var number_sequence = []
	var number = first_number
	while number < 200:
		if does_number_have_counter(number):
			number_sequence.append(number)
			number += 1
		else:
			return number_sequence
	return number_sequence


func get_highlighted_numbers() -> Array:
	var highlighted_square = get_highlighted_number_square()
	if highlighted_square != null:
		return [highlighted_square.number]
	else:
		return []


func get_all_marked_numbers() -> Array:
	var numbers = get_circled_numbers()

	for new_number in get_numbers_with_counters():
		if not numbers.has(new_number):
			numbers.append(new_number)

	for new_number in get_highlighted_numbers():
		if not numbers.has(new_number):
			numbers.append(new_number)

	return numbers


func get_marked_numbers(square_mark_type:=CountingBoardGlobals.SquareMarks.ALL) -> Array:
	match square_mark_type:
		CountingBoardGlobals.SquareMarks.CIRCLE:
			return get_circled_numbers()
		CountingBoardGlobals.SquareMarks.COUNTER:
			return get_numbers_with_counters()
		CountingBoardGlobals.SquareMarks.HIGHLIGHT:
			return get_highlighted_numbers()
		CountingBoardGlobals.SquareMarks.ALL:
			return get_all_marked_numbers()
		_:
			assert(false)
			return []


func get_contiguous_number_sequences(
			square_mark_type:=CountingBoardGlobals.SquareMarks.ALL) -> Array:
	var numbers = get_marked_numbers(square_mark_type)
	var contiguous_number_sequences = []
	var first_number = 0
	var last_number = 0
	var last_index = 0
	for index in numbers.size():
		if index == 0:
			first_number = numbers[index]
		elif numbers[index] == numbers[last_index] + 1:
			last_number = numbers[index]
		else:
			if last_number > first_number:
				contiguous_number_sequences.append([first_number, last_number])
			first_number = numbers[index]
		last_index = index
	if last_number > first_number:
		contiguous_number_sequences.append([first_number, last_number])
	return contiguous_number_sequences


func convert_to_number_sequence(start_number: int, count: int) -> Array:
	return [start_number + 1, start_number + count]


func are_all_marks_contiguous(
			square_mark_type:=CountingBoardGlobals.SquareMarks.ALL) -> bool:
	var numbers = get_marked_numbers(square_mark_type)
	var last_number = -1
	for number in numbers:
		if last_number != -1 and number != last_number + 1:
			return false
		last_number = number
	return true


func get_smallest_marked_number(
			square_mark_type:=CountingBoardGlobals.SquareMarks.ALL) -> int:
	var numbers = get_marked_numbers(square_mark_type)
	if numbers.size() > 0:
		numbers.sort()
		return numbers[0]
	return -1


func get_biggest_marked_number(
			square_mark_type:=CountingBoardGlobals.SquareMarks.ALL) -> int:
	var numbers = get_marked_numbers(square_mark_type)
	if numbers.size() > 0:
		numbers.sort()
		return numbers[-1]
	return -1


#####################################################################
# Memo-Building
#####################################################################
