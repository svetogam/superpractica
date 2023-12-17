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

var object: MyObject


class MyObject:
	extends RefCounted

	var order: Array = []

	func void_func_with_0_args() -> void:
		order.append("void")

	func func_with_1_arg(number: int) -> int:
		order.append("1 arg: " + str(number))
		return 1

	func func_with_2_args(number_1: int, number_2: int) -> int:
		order.append("2 args: " + str(number_1) + ", " + str(number_2))
		return 2


func before_each():
	object = MyObject.new()


func test_call_order():
	var group := CallableGroup.new()
	group.add(object.func_with_1_arg.bind(1))
	group.add(object.func_with_1_arg.bind(4), true)
	group.add(object.func_with_1_arg.bind(2))
	group.add(object.func_with_1_arg.bind(5), true)
	group.add(object.func_with_1_arg.bind(3))
	group.call_all()
	assert_eq(object.order, ["1 arg: 1", "1 arg: 2", "1 arg: 3", "1 arg: 4", "1 arg: 5"])


func test_call_result_order():
	var group := CallableGroup.new()
	group.add(object.void_func_with_0_args) # 1
	group.add(object.void_func_with_0_args, true) # 4
	group.add(object.func_with_1_arg.bind(1)) # 2
	group.add(object.func_with_1_arg.bind(1), true) # 5
	group.add(object.func_with_2_args.bind(2,3)) # 3
	var results := group.call_all()
	assert_eq(results, [null, 1, 2, null, 1])


func test_with_parameters_order():
	var group := CallableGroup.new()
	group.add(object.func_with_1_arg)
	group.add(object.func_with_2_args.bind(2))
	group.call_all([1])
	assert_eq(object.order, ["1 arg: 1", "2 args: 1, 2"])


func test_call_multiple_times():
	var group := CallableGroup.new()
	group.add(object.func_with_1_arg.bind(1))
	group.add(object.func_with_1_arg.bind(2), true)
	group.call_all()
	group.call_all()
	assert_eq(object.order, ["1 arg: 1", "1 arg: 2", "1 arg: 1"])


func test_remove():
	var group := CallableGroup.new()
	group.add(object.void_func_with_0_args)
	group.add(object.func_with_1_arg.bind(1))
	group.add(object.func_with_1_arg.bind(2))
	group.remove(object.void_func_with_0_args)
	group.remove(object.func_with_1_arg)
	var results_1 := group.call_all()
	group.remove(object.func_with_1_arg)
	var results_2 := group.call_all()
	assert_eq(object.order, ["1 arg: 2"])
	assert_eq(results_1, [1])
	assert_eq(results_2, [])
	assert_true(group.is_empty())

	group.remove(object.void_func_with_0_args)
	group.add(object.void_func_with_0_args)
	var results_3 := group.call_all()
	assert_eq(results_3, [null])
	assert_true(not group.is_empty())


func test_clear_and_empty():
	var group_1 := CallableGroup.new()
	var group_2 := CallableGroup.new()
	assert_true(group_1.is_empty())
	assert_true(group_2.is_empty())

	group_1.add(object.void_func_with_0_args)
	group_1.add(object.func_with_1_arg)
	group_2.add(object.void_func_with_0_args, true)
	group_2.add(object.func_with_1_arg.bind(1), true)
	assert_true(not group_1.is_empty())
	assert_true(not group_2.is_empty())

	group_1.clear()
	group_2.call_all()
	assert_true(group_1.is_empty())
	assert_true(group_2.is_empty())
