##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

extends GutTest

const ObjectScript := preload("an_object.gd")
var callbacker: KeyCallbacker


func before_each():
	callbacker = KeyCallbacker.new()


func test_call_callbacks_with_binds_and_args():
	var object = ObjectScript.new()
	callbacker.add("a", object, "set_to_5")
	callbacker.call_callbacks("a")
	assert_eq(object.value, 5)
	assert_eq(object.optional_value, ObjectScript.INITIAL_VALUE)

	callbacker.call_callbacks("a", [2])
	assert_eq(object.optional_value, 2)

	callbacker.add("a", object, "set_value", [3])
	callbacker.call_callbacks("a")
	assert_eq(object.value, 3)
	assert_eq(object.optional_value, 2)

	callbacker.call_callbacks("a", [4])
	assert_eq(object.value, 4)
	assert_eq(object.optional_value, 3)

	callbacker.add("b", object, "set_value_2", [1], true)
	callbacker.call_callbacks("b", [2])
	assert_eq(object.value_2, 1)
	assert_eq(object.optional_value, 2)


func test_one_shot_callbacks_auto_remove():
	var object = ObjectScript.new()
	callbacker.add_one_shot("a", object, "set_value")
	callbacker.call_callbacks("a", [1])
	callbacker.call_callbacks("a", [2])
	assert_eq(object.value, 1)

	callbacker.add("a", object, "set_value", [], false, true)
	callbacker.call_callbacks("a", [3])
	callbacker.call_callbacks("a", [4])
	assert_eq(object.value, 3)


func test_call_callbacks_gives_returns():
	var object = ObjectScript.new()
	callbacker.add("a", object, "set_to_5")
	callbacker.add("b", object, "return_true")
	callbacker.add("b", object, "return_false")
	assert_eq_shallow(callbacker.call_callbacks("a"), [null])
	assert_eq_shallow(callbacker.call_callbacks("b"), [true, false])


func test_callbacks_on_different_keys_do_not_get_called():
	var object_1 = ObjectScript.new()
	var object_2 = ObjectScript.new()
	callbacker.add("a", object_1, "set_to_5")
	callbacker.add("b", object_2, "set_to_5")
	callbacker.call_callbacks("a")
	assert_eq(object_1.value, 5)
	assert_eq(object_2.value, ObjectScript.INITIAL_VALUE)


func test_different_objects_with_same_method_name_get_called_separately():
	var object_1 = ObjectScript.new()
	var object_2 = ObjectScript.new()
	callbacker.add("a", object_1, "set_to_5")
	callbacker.add("a", object_2, "set_to_5")
	callbacker.call_callbacks("a")
	assert_eq(object_1.value, 5)
	assert_eq(object_2.value, 5)


func test_different_methods_on_same_object_get_called_separately():
	var object = ObjectScript.new()
	callbacker.add("a", object, "set_value")
	callbacker.add("a", object, "set_value_2")
	callbacker.call_callbacks("a", [2])
	assert_eq(object.value, 2)
	assert_eq(object.value_2, 2)


func test_call_and_check_returns():
	var object_1 = ObjectScript.new()
	var object_2 = ObjectScript.new()
	callbacker.add("a", object_1, "return_true")
	callbacker.add("a", object_2, "return_true")
	callbacker.add("b", object_1, "return_true")
	callbacker.add("b", object_2, "return_false")
	callbacker.add("c", object_1, "return_false")
	callbacker.add("c", object_2, "return_false")

	assert_eq(callbacker.do_callbacks_return_true("a"), true)
	assert_eq(callbacker.do_callbacks_return_false("a"), false)
	assert_eq(callbacker.do_callbacks_return_true("b"), false)
	assert_eq(callbacker.do_callbacks_return_false("b"), false)
	assert_eq(callbacker.do_callbacks_return_true("c"), false)
	assert_eq(callbacker.do_callbacks_return_false("c"), true)

	callbacker.do_callbacks_return_true("a", [1])
	assert_eq(object_1.optional_value, 1)
	assert_eq(object_2.optional_value, 1)


func test_poll_populated_keys():
	var object = ObjectScript.new()
	callbacker.add("a", object, "set_to_5")
	callbacker.add("b", object, "set_to_5")
	assert_eq(callbacker.has("a"), true)
	assert_eq(callbacker.has("b"), true)
	assert_eq(callbacker.has("c"), false)
	assert_eq_deep(callbacker.get_keys(), ["a", "b"])


func test_ignore_calls_by_unpopulated_key():
	callbacker.call_callbacks("a")
	assert_true(true)


func test_removed_and_cleared_callbacks_do_not_get_called():
	var object = ObjectScript.new()
	callbacker.add("a", object, "set_to_5")
	callbacker.add("b", object, "set_to_5")
	callbacker.add("c", object, "set_to_5")
	callbacker.remove("a", object, "set_to_5")
	callbacker.call_callbacks("a")
	assert_eq(object.value, ObjectScript.INITIAL_VALUE)
	assert_eq(callbacker.has("a"), false)
	assert_eq(callbacker.has("b"), true)

	callbacker.clear()
	callbacker.call_callbacks("b")
	assert_eq(object.value, ObjectScript.INITIAL_VALUE)
	assert_eq_deep(callbacker.get_keys(), [])


func test_remove_does_not_remove_other_methods_on_same_object():
	var object = ObjectScript.new()
	callbacker.add("a", object, "set_value")
	callbacker.add("a", object, "set_value_2")
	callbacker.add("a", object, "set_value_3")
	callbacker.remove("a", object, "set_value_2")
	callbacker.call_callbacks("a", [1])
	assert_eq(callbacker.has("a"), true)
	assert_eq(object.value, 1)
	assert_eq(object.value_2, ObjectScript.INITIAL_VALUE)
	assert_eq(object.value_3, 1)


func test_remove_does_not_remove_same_method_name_on_different_objects():
	var object_1 = ObjectScript.new()
	var object_2 = ObjectScript.new()
	var object_3 = ObjectScript.new()
	callbacker.add("a", object_1, "set_to_5")
	callbacker.add("a", object_2, "set_to_5")
	callbacker.add("a", object_3, "set_to_5")
	callbacker.remove("a", object_2, "set_to_5")
	callbacker.call_callbacks("a")
	assert_eq(callbacker.has("a"), true)
	assert_eq(object_1.value, 5)
	assert_eq(object_2.value, ObjectScript.INITIAL_VALUE)
	assert_eq(object_3.value, 5)
