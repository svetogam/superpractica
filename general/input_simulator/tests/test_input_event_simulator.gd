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

var input_order: Array
var simulator := MouseInputSimulator.new()


func _on_interference(_interfering_events: Array):
	var message := ("Do not perform inputs while tests are running. "
			+ InputEventSimulator.get_interference_message(_interfering_events))
	assert(false, message)


func before_all():
	add_child(simulator)
	simulator.ignore_interference(false)
	simulator.interference_detected.connect(_on_interference)


func after_all():
	simulator.interference_detected.disconnect(_on_interference)
	simulator.queue_free()


func before_each():
	simulator.reset()
	input_order.clear()


func _input(event: InputEvent):
	input_order.append(event)


func test_add_and_run_events():
	var event_1 := InputEventMouseButton.new()
	event_1.pressed = true
	event_1.double_click = false
	var event_2 := InputEventMouseButton.new()
	event_2.pressed = false
	event_2.double_click = true

	simulator.add_event(event_1)
	simulator.add_event(event_2)
	simulator.run()
	await simulator.done

	assert_eq(input_order.size(), 2)
	assert_eq(input_order[0].pressed, event_1.pressed)
	assert_eq(input_order[0].double_click, event_1.double_click)
	assert_eq(input_order[1].pressed, event_2.pressed)
	assert_eq(input_order[1].double_click, event_2.double_click)


func test_mouse_interface():
	var position_1 := Vector2(100, 100)
	var position_2 := Vector2(120, 150)
	var drag_vector := Vector2(100, 0)
	var position_3 := position_2 + drag_vector

	simulator.set_initial_mouse_position(position_1)
	simulator.click_left()
	simulator.move_to(position_2)
	simulator.press_left()
	simulator.move_by(drag_vector)
	simulator.release_left()
	simulator.run()
	await simulator.done

	assert_eq(input_order.size(), 6)
	assert_is(input_order[0], InputEventMouseButton)
	assert_eq(input_order[0].position, position_1)
	assert_eq(input_order[0].pressed, true)
	assert_eq(input_order[0].button_index, MOUSE_BUTTON_LEFT)
	assert_is(input_order[1], InputEventMouseButton)
	assert_eq(input_order[1].position, position_1)
	assert_eq(input_order[1].pressed, false)
	assert_eq(input_order[1].button_index, MOUSE_BUTTON_LEFT)
	assert_is(input_order[2], InputEventMouseMotion)
	assert_eq(input_order[2].position, position_2)
	assert_eq(input_order[2].relative, position_2 - position_1)
	assert_is(input_order[3], InputEventMouseButton)
	assert_eq(input_order[3].position, position_2)
	assert_eq(input_order[3].pressed, true)
	assert_eq(input_order[3].button_index, MOUSE_BUTTON_LEFT)
	assert_is(input_order[4], InputEventMouseMotion)
	assert_eq(input_order[4].position, position_3)
	assert_eq(input_order[4].relative, drag_vector)
	assert_is(input_order[5], InputEventMouseButton)
	assert_eq(input_order[5].position, position_3)
	assert_eq(input_order[5].pressed, false)
	assert_eq(input_order[5].button_index, MOUSE_BUTTON_LEFT)
