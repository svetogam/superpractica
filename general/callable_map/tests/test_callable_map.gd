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

const ObjectScript := preload("an_object.gd")
var callable_map: CallableMap


func before_each():
	callable_map = CallableMap.new()


func test_call_by_key_with_binds_and_args():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_to_5)
	callable_map.call_by_key("a")
	assert_eq(object.value, 5)
	assert_eq(object.optional_value, ObjectScript.INITIAL_VALUE)

	callable_map.call_by_key("a", [2])
	assert_eq(object.optional_value, 2)

	callable_map.add("a", object.set_value.bind(3))
	callable_map.call_by_key("a")
	assert_eq(object.value, 3)
	assert_eq(object.optional_value, 2)

	callable_map.call_by_key("a", [4])
	assert_eq(object.value, 4)
	assert_eq(object.optional_value, 3)


func test_one_shot_callbacks_auto_remove():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_value, true)
	callable_map.call_by_key("a", [1])
	callable_map.call_by_key("a", [2])
	assert_eq(object.value, 1)


func test_call_by_key_gives_returns():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_to_5)
	callable_map.add("b", object.return_true)
	callable_map.add("b", object.return_false)
	assert_eq(callable_map.call_by_key("a"), [null])
	assert_eq(callable_map.call_by_key("b"), [true, false])


func test_callbacks_on_different_keys_do_not_get_called():
	var object_1 := ObjectScript.new()
	var object_2 := ObjectScript.new()
	callable_map.add("a", object_1.set_to_5)
	callable_map.add("b", object_2.set_to_5)
	callable_map.call_by_key("a")
	assert_eq(object_1.value, 5)
	assert_eq(object_2.value, ObjectScript.INITIAL_VALUE)


func test_different_objects_with_same_method_name_get_called_separately():
	var object_1 := ObjectScript.new()
	var object_2 := ObjectScript.new()
	callable_map.add("a", object_1.set_to_5)
	callable_map.add("a", object_2.set_to_5)
	callable_map.call_by_key("a")
	assert_eq(object_1.value, 5)
	assert_eq(object_2.value, 5)


func test_different_methods_on_same_object_get_called_separately():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_value)
	callable_map.add("a", object.set_value_2)
	callable_map.call_by_key("a", [2])
	assert_eq(object.value, 2)
	assert_eq(object.value_2, 2)


func test_call_and_check_returns():
	var object_1 := ObjectScript.new()
	var object_2 := ObjectScript.new()
	callable_map.add("a", object_1.return_true)
	callable_map.add("a", object_2.return_true)
	callable_map.add("b", object_1.return_true)
	callable_map.add("b", object_2.return_false)
	callable_map.add("c", object_1.return_false)
	callable_map.add("c", object_2.return_false)

	var results_a = callable_map.call_by_key("a", [1])
	var results_b = callable_map.call_by_key("b")
	var results_c = callable_map.call_by_key("c")
	assert_true(results_a.has(true))
	assert_true(not results_a.has(false))
	assert_eq(object_1.optional_value, 1)
	assert_eq(object_2.optional_value, 1)
	assert_true(results_b.has(true))
	assert_true(results_b.has(false))
	assert_true(not results_c.has(true))
	assert_true(results_c.has(false))


func test_poll_populated_keys():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_to_5)
	callable_map.add("b", object.set_to_5)
	assert_eq(callable_map.has("a"), true)
	assert_eq(callable_map.has("b"), true)
	assert_eq(callable_map.has("c"), false)
	assert_eq_deep(callable_map.get_keys(), ["a", "b"])


func test_ignore_calls_by_unpopulated_key():
	callable_map.call_by_key("a")
	assert_true(true)


func test_removed_and_cleared_callbacks_do_not_get_called():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_to_5)
	callable_map.add("b", object.set_to_5)
	callable_map.add("c", object.set_to_5)
	callable_map.remove("a", object.set_to_5)
	callable_map.call_by_key("a")
	assert_eq(object.value, ObjectScript.INITIAL_VALUE)
	assert_eq(callable_map.has("a"), false)
	assert_eq(callable_map.has("b"), true)

	callable_map.clear()
	callable_map.call_by_key("b")
	assert_eq(object.value, ObjectScript.INITIAL_VALUE)
	assert_eq_deep(callable_map.get_keys(), [])


func test_remove_does_not_remove_other_methods_on_same_object():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_value)
	callable_map.add("a", object.set_value_2)
	callable_map.add("a", object.set_value_3)
	callable_map.remove("a", object.set_value_2)
	callable_map.call_by_key("a", [1])
	assert_eq(callable_map.has("a"), true)
	assert_eq(object.value, 1)
	assert_eq(object.value_2, ObjectScript.INITIAL_VALUE)
	assert_eq(object.value_3, 1)


func test_remove_does_not_remove_same_method_name_on_different_objects():
	var object_1 := ObjectScript.new()
	var object_2 := ObjectScript.new()
	var object_3 := ObjectScript.new()
	callable_map.add("a", object_1.set_to_5)
	callable_map.add("a", object_2.set_to_5)
	callable_map.add("a", object_3.set_to_5)
	callable_map.remove("a", object_2.set_to_5)
	callable_map.call_by_key("a")
	assert_eq(callable_map.has("a"), true)
	assert_eq(object_1.value, 5)
	assert_eq(object_2.value, ObjectScript.INITIAL_VALUE)
	assert_eq(object_3.value, 5)
