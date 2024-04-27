#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

extends GdUnitTestSuite

const ObjectScript := preload("an_object.gd")
var callable_map: CallableMap


func before_test():
	callable_map = CallableMap.new()


func test_call_by_key_with_binds_and_args():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_to_5)
	callable_map.call_by_key("a")
	assert_that(object.value).is_equal(5)
	assert_that(object.optional_value).is_equal(ObjectScript.INITIAL_VALUE)

	callable_map.call_by_key("a", [2])
	assert_that(object.optional_value).is_equal(2)

	callable_map.add("a", object.set_value.bind(3))
	callable_map.call_by_key("a")
	assert_that(object.value).is_equal(3)
	assert_that(object.optional_value).is_equal(2)

	callable_map.call_by_key("a", [4])
	assert_that(object.value).is_equal(4)
	assert_that(object.optional_value).is_equal(3)


func test_one_shot_callbacks_auto_remove():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_value, true)
	callable_map.call_by_key("a", [1])
	callable_map.call_by_key("a", [2])
	assert_that(object.value).is_equal(1)


func test_call_by_key_gives_returns():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_to_5)
	callable_map.add("b", object.return_true)
	callable_map.add("b", object.return_false)
	assert_array(callable_map.call_by_key("a")).contains_exactly([null])
	assert_array(callable_map.call_by_key("b")).contains_exactly([true, false])


func test_callbacks_on_different_keys_do_not_get_called():
	var object_1 := ObjectScript.new()
	var object_2 := ObjectScript.new()
	callable_map.add("a", object_1.set_to_5)
	callable_map.add("b", object_2.set_to_5)
	callable_map.call_by_key("a")
	assert_that(object_1.value).is_equal(5)
	assert_that(object_2.value).is_equal(ObjectScript.INITIAL_VALUE)


func test_different_objects_with_same_method_name_get_called_separately():
	var object_1 := ObjectScript.new()
	var object_2 := ObjectScript.new()
	callable_map.add("a", object_1.set_to_5)
	callable_map.add("a", object_2.set_to_5)
	callable_map.call_by_key("a")
	assert_that(object_1.value).is_equal(5)
	assert_that(object_2.value).is_equal(5)


func test_different_methods_on_same_object_get_called_separately():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_value)
	callable_map.add("a", object.set_value_2)
	callable_map.call_by_key("a", [2])
	assert_that(object.value).is_equal(2)
	assert_that(object.value_2).is_equal(2)


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
	assert_array(results_a).contains([true])
	assert_array(results_a).not_contains([false])
	assert_that(object_1.optional_value).is_equal(1)
	assert_that(object_2.optional_value).is_equal(1)
	assert_array(results_b).contains([true])
	assert_array(results_b).contains([false])
	assert_array(results_c).not_contains([true])
	assert_array(results_c).contains([false])


func test_poll_populated_keys():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_to_5)
	callable_map.add("b", object.set_to_5)
	assert_bool(callable_map.has("a")).is_true()
	assert_bool(callable_map.has("b")).is_true()
	assert_bool(callable_map.has("c")).is_false()
	assert_array(callable_map.get_keys()).contains_exactly(["a", "b"])


func test_removed_and_cleared_callbacks_do_not_get_called():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_to_5)
	callable_map.add("b", object.set_to_5)
	callable_map.add("c", object.set_to_5)
	callable_map.remove("a", object.set_to_5)
	callable_map.call_by_key("a")
	assert_that(object.value).is_equal(ObjectScript.INITIAL_VALUE)
	assert_bool(callable_map.has("a")).is_false()
	assert_bool(callable_map.has("b")).is_true()

	callable_map.clear()
	callable_map.call_by_key("b")
	assert_that(object.value).is_equal(ObjectScript.INITIAL_VALUE)
	assert_array(callable_map.get_keys()).is_empty()


func test_remove_does_not_remove_other_methods_on_same_object():
	var object := ObjectScript.new()
	callable_map.add("a", object.set_value)
	callable_map.add("a", object.set_value_2)
	callable_map.add("a", object.set_value_3)
	callable_map.remove("a", object.set_value_2)
	callable_map.call_by_key("a", [1])
	assert_bool(callable_map.has("a")).is_true()
	assert_that(object.value).is_equal(1)
	assert_that(object.value_2).is_equal(ObjectScript.INITIAL_VALUE)
	assert_that(object.value_3).is_equal(1)


func test_remove_does_not_remove_same_method_name_on_different_objects():
	var object_1 := ObjectScript.new()
	var object_2 := ObjectScript.new()
	var object_3 := ObjectScript.new()
	callable_map.add("a", object_1.set_to_5)
	callable_map.add("a", object_2.set_to_5)
	callable_map.add("a", object_3.set_to_5)
	callable_map.remove("a", object_2.set_to_5)
	callable_map.call_by_key("a")
	assert_bool(callable_map.has("a")).is_true()
	assert_that(object_1.value).is_equal(5)
	assert_that(object_2.value).is_equal(ObjectScript.INITIAL_VALUE)
	assert_that(object_3.value).is_equal(5)
