#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends SpFieldTest

var number_squares: Array


func _get_scene_path() -> String:
	return ("res://content/basic_addition/pims/counting_board/field/"
			+ "counting_board_field.tscn")


func before_each():
	super()
	number_squares = field.get_number_square_list()


func test_circle_squares():
	assert_eq(field.get_circled_numbers().size(), 0)

	field.toggle_circle(number_squares[0])
	field.toggle_circle(number_squares[1])
	field.toggle_circle(number_squares[23])
	assert_eq(field.get_circled_numbers().size(), 3)

	field.toggle_circle(number_squares[0])
	field.toggle_circle(number_squares[23])
	assert_eq(field.get_circled_numbers().size(), 1)


func test_mark_squares():
	assert_eq(field.get_all_marked_numbers().size(), 0)
	assert_eq(field.get_highlighted_number_square(), null)

	field.toggle_highlight(number_squares[0])
	field.toggle_highlight(number_squares[1])
	field.toggle_highlight(number_squares[23])
	assert_eq(field.get_all_marked_numbers().size(), 1)
	assert_eq(field.get_highlighted_number_square().number, 24)

	field.toggle_highlight(number_squares[23])
	assert_eq(field.get_all_marked_numbers().size(), 0)
	assert_eq(field.get_highlighted_number_square(), null)


func test_create_and_delete_counters():
	assert_eq(field.get_counter_list().size(), 0)
	assert_eq(field.get_all_marked_numbers().size(), 0)

	field.create_counter_by_number(1)
	field.create_counter_by_number(2)
	field.create_counter_by_number(24)
	field.create_counter_by_number(24)
	assert_eq(field.get_counter_list().size(), 3)
	assert_eq(field.get_all_marked_numbers().size(), 3)

	field.delete_counter_by_number(1)
	field.delete_counter_by_number(24)
	assert_eq(field.get_counter_list().size(), 1)
	assert_eq(field.get_all_marked_numbers().size(), 1)


func test_move_counters():
	field.create_counter_by_number(1)
	field.create_counter_by_number(2)
	field.create_counter_by_number(3)

	field.move_counter_by_numbers(1, 20)
	field.move_counter_by_numbers(2, 4)
	assert_eq(field.get_counter_list().size(), 3)
	assert_eq(field.get_all_marked_numbers(), [3, 4, 20])

	field.move_counter_by_numbers(3, 3)
	field.move_counter_by_numbers(3, 4)
	assert_eq(field.get_counter_list().size(), 2)
	assert_eq(field.get_all_marked_numbers(), [4, 20])


func test_undo_redo():
	var mem_states: Array = []
	mem_states.append(field.build_mem_state())
	field.toggle_circle(number_squares[0])
	mem_states.append(field.build_mem_state())
	field.toggle_highlight(number_squares[1])
	mem_states.append(field.build_mem_state())
	field.create_counter(number_squares[2])
	mem_states.append(field.build_mem_state())

	field.load_mem_state(mem_states[0])
	assert_true(not number_squares[0].circled)
	assert_true(not number_squares[1].highlighted)
	assert_true(not number_squares[2].has_counter())

	field.load_mem_state(mem_states[3])
	assert_true(number_squares[0].circled)
	assert_true(number_squares[1].highlighted)
	assert_true(number_squares[2].has_counter())

	field.load_mem_state(mem_states[1])
	assert_true(number_squares[0].circled)
	assert_true(not number_squares[1].highlighted)
	assert_true(not number_squares[2].has_counter())


func test_set_empty():
	field.toggle_circle(number_squares[0])
	field.toggle_highlight(number_squares[1])
	field.create_counter(number_squares[2])
	field.set_empty()
	assert_true(not number_squares[0].circled)
	assert_true(not number_squares[1].highlighted)
	assert_true(not number_squares[2].has_counter())
