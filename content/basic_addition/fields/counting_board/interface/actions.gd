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
# Basic Actions
#####################################################################

func create_counter(number_square: FieldObject) -> FieldObject:
	if not number_square.has_counter():
		var counter = _field.create_object(CountingBoardGlobals.Objects.COUNTER)
		counter.put_on_square(number_square)
		return counter
	return null


func create_counter_by_number(number: int) -> FieldObject:
	var number_square = _field.queries.get_number_square(number)
	var new_counter = create_counter(number_square)
	return new_counter


func delete_counter(counter: FieldObject) -> void:
	counter.queue_free()


func delete_counter_by_number(number: int) -> void:
	var counter = _field.queries.get_counter_by_number(number)
	counter.queue_free()


func move_counter(counter: FieldObject, square: FieldObject) -> void:
	counter.put_on_square(square)


func move_counter_by_numbers(from: int, to: int) -> void:
	var counter = _field.queries.get_counter_by_number(from)
	var number_square = _field.queries.get_number_square(to)
	assert(counter != null)
	assert(number_square != null)
	if from == to:
		return
	elif number_square.has_counter():
		delete_counter(counter)
	else:
		move_counter(counter, number_square)


func toggle_circle(square: FieldObject) -> void:
	square.toggle_circle()


func uncircle_squares() -> void:
	for square in _field.queries.get_number_square_list():
		if square.circled:
			square.toggle_circle()


func toggle_highlight(square: FieldObject) -> void:
	if not square.highlighted:
		highlight_single_square(square)
	else:
		unhighlight_squares()


func highlight_single_square(square: FieldObject) -> void:
	var previous_square = _field.queries.get_highlighted_number_square()
	if previous_square != null:
		previous_square.toggle_highlight()
		square.toggle_highlight()
	elif not square.highlighted:
		square.toggle_highlight()


func unhighlight_squares() -> void:
	var square = _field.queries.get_highlighted_number_square()
	if square != null:
		square.toggle_highlight()


func make_counters_transparent() -> void:
	for counter in _field.queries.get_counter_list():
		counter.set_transparent(true)


func make_counters_opaque() -> void:
	for counter in _field.queries.get_counter_list():
		counter.set_transparent(false)


func give_number_effect_by_number_square(square: FieldObject) -> NumberEffect:
	return _field.math_effects.give_number(square.number, square.global_position, "grow")


func give_number_effect_by_number(number: int) -> NumberEffect:
	var number_square = _field.queries.get_number_square(number)
	return give_number_effect_by_number_square(number_square)


func count_counter(counter: FieldObject) -> NumberEffect:
	return _field.counter.count_next(counter.global_position)


func count_square(number: int) -> NumberEffect:
	var square = _field.queries.get_number_square(number)
	return _field.counter.count_next(square.global_position)


#####################################################################
# Field-Setting
#####################################################################

func set_empty() -> void:
	for counter in _field.queries.get_counter_list():
		counter.queue_free()

	uncircle_squares()
	unhighlight_squares()
	_field.clear_effects()
