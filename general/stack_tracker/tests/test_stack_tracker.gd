#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

extends GutTest

var stack_tracker: StackTracker


func _add_numbers():
	stack_tracker.push_item(1)
	stack_tracker.push_item(2)
	stack_tracker.push_item(3)


func before_each():
	stack_tracker = StackTracker.new(20, true)
	stack_tracker.push_item(-1)


func test_initializes_to_expected_state():
	assert_eq(stack_tracker.get_current_item(), -1)
	assert_eq(stack_tracker.get_current_position(), 1)


func test_position_locked_in_initial_state():
	var position := stack_tracker.get_current_position()
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_position(), position)
	stack_tracker.move_position_forward()
	assert_eq(stack_tracker.get_current_position(), position)


func test_navigate_forward_and_back():
	_add_numbers()
	assert_eq(stack_tracker.get_current_position(), 4)
	stack_tracker.move_position_forward()
	assert_eq(stack_tracker.get_current_position(), 4)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_position(), 3)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_position(), 2)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_position(), 1)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_position(), 1)


func test_navigate_by_set_position():
	_add_numbers()
	assert_eq(stack_tracker.get_current_position(), 4)
	stack_tracker.set_position(2)
	assert_eq(stack_tracker.get_current_position(), 2)
	stack_tracker.set_position(1)
	assert_eq(stack_tracker.get_current_position(), 1)
	stack_tracker.set_position(4)
	assert_eq(stack_tracker.get_current_position(), 4)

	# Should crash
#	stack_tracker.set_position(100)
#	stack_tracker.set_position(0)
#	stack_tracker.set_position(5)



func test_get_pushed_items():
	_add_numbers()
	assert_eq(stack_tracker.get_current_item(), 3)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_item(), 2)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_item(), 1)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_item(), -1)


func test_is_position_at_front_or_back():
	assert_true(stack_tracker.is_position_at_front())
	assert_true(stack_tracker.is_position_at_back())

	_add_numbers()
	assert_false(stack_tracker.is_position_at_back())
	assert_true(stack_tracker.is_position_at_front())
	stack_tracker.set_position(2)
	assert_false(stack_tracker.is_position_at_back())
	assert_false(stack_tracker.is_position_at_front())
	stack_tracker.set_position(1)
	assert_true(stack_tracker.is_position_at_back())
	assert_false(stack_tracker.is_position_at_front())


func test_add_numbers_in_middle():
	_add_numbers()
	stack_tracker.set_position(2)
	stack_tracker.push_item(4)
	stack_tracker.push_item(5)

	assert_eq(stack_tracker.get_current_item(), 5)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_item(), 4)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_item(), 1)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_item(), -1)


func test_add_numbers_at_start():
	_add_numbers()
	stack_tracker.set_position(1)
	stack_tracker.push_item(4)
	stack_tracker.push_item(5)

	assert_eq(stack_tracker.get_current_item(), 5)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_item(), 4)
	stack_tracker.move_position_back()
	assert_eq(stack_tracker.get_current_item(), -1)


func test_add_numbers_beyond_max_capacity():
	for i in range(30):
		stack_tracker.push_item(i)

	var expected_final_item: int = 29
	var expected_first_item: int = 10
	assert_eq(stack_tracker.get_current_item(), expected_final_item)
	assert_eq(stack_tracker.get_current_position(), 20)

	var expected_item: int = expected_final_item - 1
	while(not stack_tracker.is_position_at_back()):
		stack_tracker.move_position_back()
		assert_eq(stack_tracker.get_current_item(), expected_item)
		expected_item -= 1
	assert_eq(stack_tracker.get_current_item(), expected_first_item)
