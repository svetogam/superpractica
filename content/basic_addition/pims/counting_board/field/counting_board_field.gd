#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name CountingBoard
extends Field

#====================================================================
# Globals
#====================================================================
#region

enum Objects {
	NUMBER_SQUARE,
	COUNTER,
}
enum Tools {
	NONE = GameGlobals.NO_TOOL,
	NUMBER_CIRCLER,
	SQUARE_MARKER,
	COUNTER_CREATOR,
	COUNTER_DELETER,
	COUNTER_DRAGGER,
	MEMO_GRABBER,
}
enum SquareMarks {
	ALL = 0,
	CIRCLE,
	COUNTER,
	HIGHLIGHT,
}

const ObjectNumberSquare := preload("objects/number_square/number_square.tscn")
const ObjectCounter := preload("objects/counter/counter.tscn")

const ProcessCountCounters := preload("processes/count_counters.gd")
const ProcessCountCirclesInDirection := preload("processes/count_circles_in_direction.gd")
const ProcessCountSquares := preload("processes/count_squares.gd")
const ProcessEmptyCountSquare := preload("processes/empty_count_square.gd")
const ProcessCircleNumbersInDirection := preload(
		"processes/circle_numbers_in_direction.gd")
const ProcessAddByCircles := preload("processes/add_by_circles.gd")


func get_field_type() -> String:
	return "CountingBoard"


static func _get_interface_data() -> PimInterfaceData:
	return preload("interface_data.gd").new()


#endregion
#====================================================================
# Behavior
#====================================================================
#region

func _on_update(_update_type: int) -> void:
	pass


func reset_state() -> void:
	push_action(set_empty)


func _incoming_drop(object: InterfieldObject, point: Vector2, _source: Field) -> void:
	if (object.object_type == CountingBoard.Objects.COUNTER
			or object.object_type == BubbleSum.Objects.UNIT):
		var square = get_number_square_at_point(point)
		if square != null and not square.has_counter():
			push_action(create_counter.bind(square))


func _outgoing_drop(object: FieldObject) -> void:
	if object.object_type == CountingBoard.Objects.COUNTER:
		push_action(delete_counter.bind(object))


#endregion
#====================================================================
# Queries
#====================================================================
#region

#--------------------------------------
# Object-Finding
#--------------------------------------

func get_number_square_list() -> Array:
	return get_objects_in_group("number_squares")


func get_counter_list() -> Array:
	return get_objects_in_group("counters")


func get_number_square_at_point(point: Vector2) -> NumberSquare:
	var number_squares := get_number_square_list()
	for number_square in number_squares:
		if number_square.has_point(point):
			return number_square
	return null


func get_number_square(number: int) -> NumberSquare:
	var number_squares := get_number_square_list()
	for number_square in number_squares:
		if number_square.number == number:
			return number_square
	return null


func get_number_squares_by_numbers(number_list: Array) -> Array:
	var number_squares: Array = []
	for number in number_list:
		var number_square := get_number_square(number)
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
	var circled_squares: Array = []
	var squares := get_number_square_list()
	for square in squares:
		if square.circled:
			circled_squares.append(square)
	return circled_squares


func get_number_squares_with_counters() -> Array:
	var squares: Array = []
	var counters := get_counter_list()
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
	var number_square := get_number_square(number)
	return get_counter_on_square(number_square)


#--------------------------------------
# Analysis
#--------------------------------------

func get_circled_numbers() -> Array:
	var numbers: Array = []
	var squares := get_circled_number_squares()
	for square in squares:
		numbers.append(square.number)
	numbers.sort()
	return numbers


func is_number_circled(number: int) -> bool:
	return get_circled_numbers().has(number)


func get_numbers_with_counters() -> Array:
	var numbers: Array = []
	var squares := get_number_squares_with_counters()
	for square in squares:
		numbers.append(square.number)
	numbers.sort()
	return numbers


func does_number_have_counter(number: int) -> bool:
	return get_numbers_with_counters().has(number)


func get_numbers_between(start_number: int, end_number: int, skip_count_tens: bool
) -> Array:
	if skip_count_tens and end_number >= start_number + 10:
		var numbers: Array = []
		numbers += get_numbers_by_skip_count(start_number, 10, end_number)
		if numbers[-1] == end_number:
			numbers.pop_back()
		else:
			numbers += range(numbers[-1] + 1, end_number)
		return numbers
	else:
		return range(start_number + 1, end_number)


func get_numbers_by_skip_count(start_number: int, skip_count: int,
		bound_number: int = 100
) -> Array:
	var numbers := range(start_number, bound_number + 1, skip_count)
	numbers.remove_at(0)
	return numbers


func get_numbers_in_direction(start_number: int, number_of_numbers: int,
		direction: String
) -> Array:
	var skip_count: int = {"right": 1, "down": 10} [direction]
	var bound_number := start_number + number_of_numbers * skip_count
	return get_numbers_by_skip_count(start_number, skip_count, bound_number)


func get_circled_numbers_by_skip_count(start_number: int, skip_count: int,
		bound_number: int = 100
) -> Array:
	var counted_numbers := get_numbers_by_skip_count(
			start_number, skip_count, bound_number)
	var circled_numbers: Array = []
	for number in counted_numbers:
		var square := get_number_square(number)
		if square.circled:
			circled_numbers.append(number)
		else:
			return circled_numbers
	return circled_numbers


func get_circled_numbers_in_direction(start_number: int, direction: String) -> Array:
	var skip_count: int = {"right": 1, "down": 10} [direction]
	return get_circled_numbers_by_skip_count(start_number, skip_count)


func get_contiguous_numbers_with_counters_from(first_number: int) -> Array:
	var number_sequence: Array = []
	var number := first_number
	while number < 200:
		if does_number_have_counter(number):
			number_sequence.append(number)
			number += 1
		else:
			return number_sequence
	return number_sequence


func get_highlighted_numbers() -> Array:
	var highlighted_square := get_highlighted_number_square()
	if highlighted_square != null:
		return [highlighted_square.number]
	else:
		return []


func get_all_marked_numbers() -> Array:
	var numbers := get_circled_numbers()

	for new_number in get_numbers_with_counters():
		if not numbers.has(new_number):
			numbers.append(new_number)

	for new_number in get_highlighted_numbers():
		if not numbers.has(new_number):
			numbers.append(new_number)

	return numbers


func get_marked_numbers(square_mark_type := CountingBoard.SquareMarks.ALL) -> Array:
	match square_mark_type:
		CountingBoard.SquareMarks.CIRCLE:
			return get_circled_numbers()
		CountingBoard.SquareMarks.COUNTER:
			return get_numbers_with_counters()
		CountingBoard.SquareMarks.HIGHLIGHT:
			return get_highlighted_numbers()
		CountingBoard.SquareMarks.ALL:
			return get_all_marked_numbers()
		_:
			assert(false)
			return []


func get_contiguous_number_sequences(square_mark_type := CountingBoard.SquareMarks.ALL
) -> Array:
	var numbers := get_marked_numbers(square_mark_type)
	var contiguous_number_sequences: Array = []
	var first_number: int = 0
	var last_number: int = 0
	var last_index: int = 0
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


func are_all_marks_contiguous(square_mark_type := CountingBoard.SquareMarks.ALL) -> bool:
	var numbers := get_marked_numbers(square_mark_type)
	var last_number: int = -1
	for number in numbers:
		if last_number != -1 and number != last_number + 1:
			return false
		last_number = number
	return true


func get_smallest_marked_number(square_mark_type := CountingBoard.SquareMarks.ALL) -> int:
	var numbers := get_marked_numbers(square_mark_type)
	if numbers.size() > 0:
		numbers.sort()
		return numbers[0]
	return -1


func get_biggest_marked_number(square_mark_type := CountingBoard.SquareMarks.ALL) -> int:
	var numbers := get_marked_numbers(square_mark_type)
	if numbers.size() > 0:
		numbers.sort()
		return numbers[-1]
	return -1


#endregion
#====================================================================
# Actions
#====================================================================
#region

#--------------------------------------
# Basic Actions
#--------------------------------------

func create_counter(number_square: NumberSquare) -> FieldObject:
	if not number_square.has_counter():
		var counter := CountingBoard.ObjectCounter.instantiate() as FieldObject
		add_child(counter)
		counter.put_on_square(number_square)
		return counter
	return null


func create_counter_by_number(number: int) -> FieldObject:
	var number_square = get_number_square(number)
	var new_counter := create_counter(number_square)
	return new_counter


func delete_counter(counter: FieldObject) -> void:
	counter.queue_free()


func delete_counter_by_number(number: int) -> void:
	var counter = get_counter_by_number(number)
	counter.queue_free()


func move_counter(counter: FieldObject, square: NumberSquare) -> void:
	counter.put_on_square(square)


func move_counter_by_numbers(from: int, to: int) -> void:
	var counter = get_counter_by_number(from)
	var number_square = get_number_square(to)
	assert(counter != null)
	assert(number_square != null)
	if from == to:
		return
	elif number_square.has_counter():
		delete_counter(counter)
	else:
		move_counter(counter, number_square)


func toggle_circle(square: NumberSquare) -> void:
	square.toggle_circle()


func uncircle_squares() -> void:
	for square in get_number_square_list():
		if square.circled:
			square.toggle_circle()


func toggle_highlight(square: NumberSquare) -> void:
	if not square.highlighted:
		highlight_single_square(square)
	else:
		unhighlight_squares()


func highlight_single_square(square: NumberSquare) -> void:
	var previous_square = get_highlighted_number_square()
	if previous_square != null:
		previous_square.toggle_highlight()
		square.toggle_highlight()
	elif not square.highlighted:
		square.toggle_highlight()


func unhighlight_squares() -> void:
	var square = get_highlighted_number_square()
	if square != null:
		square.toggle_highlight()


func make_counters_transparent() -> void:
	for counter in get_counter_list():
		counter.set_transparent(true)


func make_counters_opaque() -> void:
	for counter in get_counter_list():
		counter.set_transparent(false)


func give_number_effect_by_number_square(square: NumberSquare) -> NumberEffect:
	return math_effects.give_number(square.number, square.global_position, "grow")


func give_number_effect_by_number(number: int) -> NumberEffect:
	var number_square = get_number_square(number)
	return give_number_effect_by_number_square(number_square)


func count_counter(counter: FieldObject) -> NumberEffect:
	return effect_counter.count_next(counter.global_position)


func count_square(number: int) -> NumberEffect:
	var square = get_number_square(number)
	return effect_counter.count_next(square.global_position)


#--------------------------------------
# Field-Setting
#--------------------------------------

func set_empty() -> void:
	for counter in get_counter_list():
		counter.queue_free()

	uncircle_squares()
	unhighlight_squares()
	clear_effects()


#endregion
#====================================================================
# History
#====================================================================
#region

#--------------------------------------
# State Building
#--------------------------------------

const MemStateClass := preload("mem_state.gd")


func build_mem_state() -> MemState:
	var data_list := _get_number_squares_data_list()
	return MemStateClass.new(data_list)


func _get_number_squares_data_list() -> Array:
	var data_list: Array = []
	for square in get_number_square_list():
		var square_data := _get_square_data(square)
		data_list.append(square_data)
	return data_list


func _get_square_data(square: NumberSquare) -> Dictionary:
	return {"number": square.number, "circled": square.circled,
			"highlighted": square.highlighted,
			"has_counter": square.has_counter()}


#--------------------------------------
# State Loading
#--------------------------------------

func load_mem_state(state: MemState) -> void:
	set_empty()
	_set_squares_by_data_list(state.number_squares_data_list)

	_trigger_update(UpdateTypes.STATE_LOADED)


func _set_squares_by_data_list(number_squares_data_list: Array) -> void:
	for square_data in number_squares_data_list:
		var number_square = get_number_square(square_data.number)
		if square_data.circled:
			toggle_circle(number_square)
		if square_data.highlighted:
			toggle_highlight(number_square)
		if square_data.has_counter:
			create_counter(number_square)


#endregion
