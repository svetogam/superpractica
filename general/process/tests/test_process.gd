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


func before_each():
	context = Context.new()
	add_child(context)


func after_each():
	remove_child(context)


# Gut bugs out with this one, causing other tests to fail
#func test_run_process_order():
	#var process_1 := ProcessScript.new()
	#var process_2 := ProcessScene.instantiate()
	#watch_signals(process_1)
	#watch_signals(process_2)
	#assert_eq(process_1.parent, null)
	#assert_eq(process_2.parent, null)
	#assert_eq_deep(process_1.order, ["setup"])
	#assert_eq_deep(process_2.order, ["setup"])
#
	#process_1.run(context)
	#process_2.run(context)
	#assert_eq(process_1.parent.get_instance_id(), context.get_instance_id())
	#assert_eq(process_2.parent.get_instance_id(), context.get_instance_id())
	#assert_eq_deep(process_1.order, ["setup", "setup_with_parent", "running"])
	#assert_eq_deep(process_2.order, ["setup", "setup_with_parent", "running"])
	#assert_signal_not_emitted(process_1, "completed")
	#assert_signal_not_emitted(process_2, "completed")
#
	#process_1.complete()
	#wait_for_signal(process_1.tree_exited, 1)
	#assert_signal_emitted(process_1, "completed")
	#process_2.complete()
	#wait_for_signal(process_2.tree_exited, 1)
	#assert_signal_emitted(process_2, "completed")


func test_run_process_with_callbacks():
	var process_1 := ProcessScript.new().run(context, context.func_with_0_args)
	var process_2 := ProcessScript.new().run(context, context.func_with_1_arg)
	var process_3 := ProcessScript.new().run(context, context.func_with_2_args)
	var process_4 := ProcessScript.new().run(context, context.func_with_2_args.bind(5))
	process_1.complete()
	process_2.complete(1)
	process_3.complete(2, 3)
	process_4.complete(4)
	assert_eq_deep(context.order, ["0 args", "1 arg: 1", "2 args: 2, 3", "2 args: 4, 5"])


func test_emit_completed_signal_with_parameters():
	var process_1 := ProcessScript.new().run(context)
	var process_2 := ProcessScript.new().run(context)
	var process_3 := ProcessScript.new().run(context)
	watch_signals(process_1)
	watch_signals(process_2)
	watch_signals(process_3)
	process_1.complete()
	process_2.complete(1)
	process_3.complete(1, 2)
	assert_signal_emitted_with_parameters(process_1, "completed", [])
	assert_signal_emitted_with_parameters(process_2, "completed", [1])
	assert_signal_emitted_with_parameters(process_3, "completed", [1, 2])
