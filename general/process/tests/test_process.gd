# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

extends GdUnitTestSuite

const ProcessScript := preload("a_process.gd")
const ProcessScene := preload("a_process.tscn")
var context: Context

class Context:
	extends Node

	var order: Array = []

	func func_with_0_args() -> void:
		order.append("0 args")

	func func_with_1_arg(number: int) -> void:
		order.append("1 arg: " + str(number))

	func func_with_2_args(number_1: int, number_2: int) -> void:
		order.append("2 args: " + str(number_1) + ", " + str(number_2))


func before_test():
	context = Context.new()
	add_child(context)


func after_test():
	context.free()


# Test is broken. This is due to the process freeing itself upon completion.
#func test_run_process_order():
	#var process_1 := ProcessScript.new()
	#var process_2 := ProcessScene.instantiate()
	#monitor_signals(process_1)
	#monitor_signals(process_2)
	#assert_object(process_1.parent).is_null()
	#assert_object(process_2.parent).is_null()
	#assert_array(process_1.order).is_equal(["setup"])
	#assert_array(process_2.order).is_equal(["setup"])
#
	#process_1.run(context)
	#process_2.run(context)
	#assert_int(process_1.parent.get_instance_id()).is_equal(context.get_instance_id())
	#assert_int(process_2.parent.get_instance_id()).is_equal(context.get_instance_id())
	#assert_array(process_1.order).is_equal(["setup", "setup_with_parent", "running"])
	#assert_array(process_2.order).is_equal(["setup", "setup_with_parent", "running"])
#
	#process_1.complete()
	#await assert_signal(process_1).is_emitted("completed")
	#process_2.complete()
	#await assert_signal(process_2).is_emitted("completed")


func test_run_process_with_callbacks():
	var process_1 := ProcessScript.new().run(context, context.func_with_0_args)
	var process_2 := ProcessScript.new().run(context, context.func_with_1_arg)
	var process_3 := ProcessScript.new().run(context, context.func_with_2_args)
	var process_4 := ProcessScript.new().run(context, context.func_with_2_args.bind(5))
	process_1.complete()
	process_2.complete(1)
	process_3.complete(2, 3)
	process_4.complete(4)
	assert_array(context.order).is_equal(
			["0 args", "1 arg: 1", "2 args: 2, 3", "2 args: 4, 5"])


# Test is broken. This is due to the process freeing itself upon completion.
#func test_emit_completed_signal_with_parameters():
	#var process_1 := ProcessScript.new().run(context)
	#var process_2 := ProcessScript.new().run(context)
	#var process_3 := ProcessScript.new().run(context)
	#monitor_signals(process_1)
	#monitor_signals(process_2)
	#monitor_signals(process_3)
	#process_1.complete()
	#process_2.complete(1)
	#process_3.complete(1, 2)
	#await assert_signal(process_1).is_emitted("completed", [])
	#await assert_signal(process_2).is_emitted("completed", [1])
	#await assert_signal(process_3).is_emitted("completed", [1, 2])
