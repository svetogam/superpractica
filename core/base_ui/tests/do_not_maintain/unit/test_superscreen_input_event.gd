#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends GutTest

const TEST_POSITION = Vector2(100, 100)
const TEST_POSITION_CHANGE = Vector2(10, 10)


func _simulate_mouse_press():
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = TEST_POSITION
	return event


func _simulate_mouse_motion():
	var event = InputEventMouseMotion.new()
	event.position = TEST_POSITION
	event.relative = TEST_POSITION_CHANGE
	return event


func _simulate_mouse_release():
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = false
	event.position = TEST_POSITION
	return event


func test_press():
	var gd_input_event = _simulate_mouse_press()
	var input_event = SuperscreenInputEvent.new(gd_input_event)

	assert_eq(input_event.is_press(), true)
	assert_eq(input_event.is_motion(), false)
	assert_eq(input_event.is_release(), false)
	assert_eq(input_event.get_position(), TEST_POSITION)
	assert_eq(input_event.get_change(), Vector2.ZERO)
	assert_eq(input_event.get_grabbed_object(), null)
	assert_eq(input_event.is_object_grabbed(), false)


func test_move_mouse():
	var gd_input_event = _simulate_mouse_motion()
	var input_event = SuperscreenInputEvent.new(gd_input_event)

	assert_eq(input_event.is_press(), false)
	assert_eq(input_event.is_motion(), true)
	assert_eq(input_event.is_release(), false)
	assert_eq(input_event.get_position(), TEST_POSITION)
	assert_eq(input_event.get_change(), TEST_POSITION_CHANGE)
	assert_eq(input_event.get_grabbed_object(), null)
	assert_eq(input_event.is_object_grabbed(), false)


func test_release():
	var gd_input_event = _simulate_mouse_release()
	var input_event = SuperscreenInputEvent.new(gd_input_event)

	assert_eq(input_event.is_press(), false)
	assert_eq(input_event.is_motion(), false)
	assert_eq(input_event.is_release(), true)
	assert_eq(input_event.get_position(), TEST_POSITION)
	assert_eq(input_event.get_change(), Vector2.ZERO)
	assert_eq(input_event.get_grabbed_object(), null)
	assert_eq(input_event.is_object_grabbed(), false)


func test_has_grabbed_object():
	var gd_input_event = _simulate_mouse_release()
	var grabbed_object = double(InputObject).new()
	var input_event = SuperscreenInputEvent.new(gd_input_event, grabbed_object)

	assert_eq(input_event.get_grabbed_object(), grabbed_object)
	assert_eq(input_event.is_object_grabbed(), true)


func test_complete():
	var gd_input_event = _simulate_mouse_press()
	var input_event = SuperscreenInputEvent.new(gd_input_event)

	assert_eq(input_event.is_active(), true)
	assert_eq(input_event.is_completed(), false)

	input_event.complete()
	assert_eq(input_event.is_active(), false)
	assert_eq(input_event.is_completed(), true)


func test_deactivate_and_complete():
	var gd_input_event = _simulate_mouse_press()
	var input_event = SuperscreenInputEvent.new(gd_input_event)

	assert_eq(input_event.is_active(), true)
	assert_eq(input_event.is_completed(), false)

	input_event.deactivate()
	assert_eq(input_event.is_active(), false)
	assert_eq(input_event.is_completed(), false)

	input_event.complete()
	assert_eq(input_event.is_active(), false)
	assert_eq(input_event.is_completed(), true)
