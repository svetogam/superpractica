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

const ContextScene := preload("a_context.tscn")
const ProcessScript := preload("a_process.gd")
var context: Node


func before_each():
	context = ContextScene.instance()
	add_child(context)


func after_each():
	remove_child(context)


func test_run_process():
	var process = ProcessScript.new()
	assert_eq_deep(context.order, [])

	process.run_on(context)
	assert_eq_deep(context.order, ["process_entered", "process_ready"])

	context.order.clear()
	process.complete()
	assert_eq_deep(context.order, [])

	context.order.clear()
	yield(process, "tree_exited")
	assert_eq_deep(context.order, ["process_exited"])


func test_run_process_with_callback():
	var process = ProcessScript.new()
	process.run_on(context, context, "small_callback", [1])
	process.complete()
	var expected = ["process_entered", "process_ready", "small_callback: 1"]
	assert_eq_deep(context.order, expected)

	context.order.clear()
	process = ProcessScript.new()
	process.connect_callback(context, "small_callback", [2])
	process.run_on(context)
	process.complete()
	expected = ["process_entered", "process_ready", "small_callback: 2"]
	assert_eq_deep(context.order, expected)


func test_emits_completed_signal():
	var process = ProcessScript.new()
	watch_signals(process)
	process.run_on(context)
	assert_signal_not_emitted(process, "completed")

	process.complete()
	assert_signal_emitted_with_parameters(process, "completed", [])

	process = ProcessScript.new()
	watch_signals(process)
	process.run_on(context)
	process.complete([1, 2])
	assert_signal_emitted_with_parameters(process, "completed", [1, 2])


func test_run_process_with_callback_binds_and_completion_parameters():
	var process = ProcessScript.new()
	process.run_on(context, context, "big_callback", [2])
	context.order.clear()
	process.complete([1])
	assert_eq_deep(context.order, ["big_callback: 1, 2"])


func test_run_process_by_static_method():
	var process = Process.create_and_run_on(ProcessScript, context, true)
	assert_true(process.was_setup)
	assert_eq_deep(context.order, ["process_entered", "process_ready"])
