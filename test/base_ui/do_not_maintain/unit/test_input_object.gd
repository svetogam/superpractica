##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends GutTest

var ObjectScene: PackedScene
var utils := TestingUtils.new(self)
var input_object: InputObject
var superscreen: Superscreen
var input_shape: InputShape
var input_event: SuperscreenInputEvent


class TestSuperscreenInputEvent:
	extends SuperscreenInputEvent
	func _init().(null): pass


func before_each():
	superscreen = double(Superscreen).new()

	input_object = InputObject.new()
	add_child(input_object)
	input_shape = double(InputShape).new()
	input_object.input_shape = input_shape

	input_event = double(self.get_script(), "TestSuperscreenInputEvent").new()


func after_each():
	remove_child(input_object)


func test_initial_state():
	assert_true(input_object.input_priority == 0)
	assert_true(input_object.is_in_group("input_objects"))


func test_take_hover_input():
	watch_signals(input_object)
	_assert_input_vars_trigger_signals(false, false, false, "press", [])
	_assert_input_vars_trigger_signals(false, true, false, "press", [])
	_assert_input_vars_trigger_signals(true, true, false, "press", [])
	_assert_input_vars_trigger_signals(true, false, false, "press", ["hovered"])


func test_ignore_inactive_input_except_for_hover():
	watch_signals(input_object)
	_assert_input_vars_trigger_signals(true, false, false, "press", ["hovered"])
	_assert_input_vars_trigger_signals(true, false, false, "motion", ["hovered"])
	_assert_input_vars_trigger_signals(true, false, false, "release", ["hovered"])


func test_take_unhover_input():
	watch_signals(input_object)
	_assert_input_vars_trigger_signals(true, false, false, "motion", ["hovered"])
	_assert_input_vars_trigger_signals(false, false, false, "motion", ["hovered", "unhovered"])


func test_take_press_input():
	watch_signals(input_object)
	_assert_input_vars_trigger_signals(false, false, true, "press", [])
	_assert_input_vars_trigger_signals(true, false, true, "press", ["hovered", "pressed"])


func test_take_drag_input():
	watch_signals(input_object)
	_assert_input_vars_trigger_signals(false, false, true, "motion", [])
	_assert_input_vars_trigger_signals(false, true, true, "motion", ["dragged"])


func test_take_drop_input():
	watch_signals(input_object)
	_assert_input_vars_trigger_signals(false, false, true, "release", [])
	_assert_input_vars_trigger_signals(false, true, true, "release", ["dropped"])


func _assert_input_vars_trigger_signals(hit: bool, grabbed: bool, active: bool,
			input_type: String, expected: Array):
	stub(input_object.input_shape, "has_point").to_return(hit)
	stub(input_event, "get_position").to_return(Vector2.ZERO)
	stub(input_event, "get_change").to_return(Vector2.ZERO)
	if grabbed:
		stub(input_event, "get_grabbed_object").to_return(input_object)
	else:
		stub(input_event, "get_grabbed_object").to_return(null)
	stub(input_event, "is_active").to_return(active)
	match input_type:
		"press":
			stub(input_event, "is_press").to_return(true)
		"motion":
			stub(input_event, "is_motion").to_return(true)
		"release":
			stub(input_event, "is_release").to_return(true)
		"_":
			assert(false)

	input_object.take_input(input_event)

	var checked = ["hovered", "unhovered", "pressed", "dragged", "dropped"]
	utils.assert_expected_signals_emitted(input_object, checked, expected)


func test_start_and_stop_grab():
	watch_signals(input_object)

	input_object.start_grab()
	assert_signal_emitted(input_object, "grab_started")

	input_object.stop_grab()
	assert_signal_emitted(input_object, "grab_stopped")


func test_has_input_priority():
	var input_objects = []
	for _i in range(8):
		var x = InputObject.new()
		add_child(x)
		input_objects.append(x)

	input_objects[1].z_index = 1
	input_objects[2].input_priority = 1
	input_objects[3].input_priority = 1
	input_objects[3].z_index = 1
	input_objects[5].z_index = 1
	input_objects[6].input_priority = 1
	input_objects[7].input_priority = 1
	input_objects[7].z_index = 1

	#False for the same object
	assert_false(input_objects[0].has_input_priority_over_other(input_objects[0]))

	#Works both ways
	assert_true(input_objects[7].has_input_priority_over_other(input_objects[0]))
	assert_false(input_objects[0].has_input_priority_over_other(input_objects[7]))

	#Explicitly set input priority always has precedence
	assert_true(input_objects[2].has_input_priority_over_other(input_objects[5]))
	assert_true(input_objects[3].has_input_priority_over_other(input_objects[5]))
	assert_true(input_objects[6].has_input_priority_over_other(input_objects[5]))
	assert_true(input_objects[7].has_input_priority_over_other(input_objects[5]))

	#Higher z_index is the second most important factor
	assert_true(input_objects[1].has_input_priority_over_other(input_objects[4]))
	assert_true(input_objects[3].has_input_priority_over_other(input_objects[6]))

	#Being added later gives input priority when other factors are equal
	assert_true(input_objects[4].has_input_priority_over_other(input_objects[0]))
	assert_true(input_objects[5].has_input_priority_over_other(input_objects[1]))
	assert_true(input_objects[6].has_input_priority_over_other(input_objects[2]))
	assert_true(input_objects[7].has_input_priority_over_other(input_objects[3]))

	for object in input_objects:
		object.free()
