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
var FactoryData := preload("factory_data.gd")
var factory_data := FactoryData.get_data()
var context: Node
var factory: NodeFactory
var factory_with_target: NodeFactory
var factory_with_empty_data: NodeFactory


func before_each():
	context = ContextScene.instantiate()
	add_child(context)
	factory = $Context/Factory
	factory_with_target = $Context/FactoryWithTarget
	factory_with_empty_data = $Context/FactoryWithEmptyData


func after_each():
	remove_child(context)


func test_create_node_by_script() -> void:
	watch_signals(factory)
	var node = factory.create("a_script")
	context.add_child(node)
	assert_signal_emitted_with_parameters(factory, "created", ["a_script", node])
	assert_signal_emitted_with_parameters(factory, "created_a_script", [node])

	factory.create_on("a_script", context)
	assert_eq_deep(context.order, ["script_ready", "script_ready"])


func test_create_node_by_scene() -> void:
	watch_signals(factory)
	var node = factory.create("a_scene")
	context.add_child(node)
	assert_signal_emitted_with_parameters(factory, "created", ["a_scene", node])
	assert_signal_emitted_with_parameters(factory, "created_a_scene", [node])

	factory.create_on("a_scene", context)
	assert_eq_deep(context.order, ["script_ready", "script_ready"])


func test_create_node_with_target_path() -> void:
	factory_with_target.create("a_script")
	factory_with_target.create("a_scene")
	assert_eq_deep(context.order, ["script_ready", "script_ready"])


#This doesn't test create_on overriding factory_with_target though
func test_priority_of_targets() -> void:
	var node_1 = factory.create("a_script")
	var node_2 = factory.create_on("a_script", context)
	var node_3 = factory.create_on("a_script", null)
	var node_4 = factory_with_target.create("a_script")
	var node_5 = factory_with_target.create_on("a_script", context)
	var node_6 = factory_with_target.create_on("a_script", null)
	assert_true(node_1.get_parent() == null)
	assert_true(node_2.get_parent() == context)
	assert_true(node_3.get_parent() == null)
	assert_true(node_4.get_parent() == context)
	assert_true(node_5.get_parent() == context)
	assert_true(node_6.get_parent() == null)


func test_connect_setup() -> void:
	factory.connect_setup("a_script", "setup")
	var node_1 = factory.create("a_script")
	var node_2 = factory.create("a_scene")
	assert_true(node_1.was_setup)
	assert_true(not node_2.was_setup)


func test_connect_setup_on_all() -> void:
	factory.connect_setup_on_all("setup")
	var node_1 = factory.create("a_script")
	var node_2 = factory.create("a_scene")
	assert_true(node_1.was_setup)
	assert_true(node_2.was_setup)


func test_create_node_with_args_and_setup_binds() -> void:
	watch_signals(factory)
	factory.connect_setup("a_script", "setup_with_numbers", [4])
	var node_1 = factory.create("a_script", [5])
	assert_true(node_1.was_setup)
	assert_eq_deep(node_1.setup_vars, [5, 4, 3])
	assert_signal_emitted_with_parameters(factory, "created", ["a_script", node_1, 5])
	assert_signal_emitted_with_parameters(factory, "created_a_script", [node_1, 5])

	clear_signal_watcher()
	watch_signals(factory)
	factory.connect_setup("a_scene", "setup_with_numbers", [6])
	var node_2 = factory.create_on("a_scene", context, [7])
	assert_true(node_2.was_setup)
	assert_eq_deep(node_2.setup_vars, [7, 6, 3])
	assert_signal_emitted_with_parameters(factory, "created", ["a_scene", node_2, 7])
	assert_signal_emitted_with_parameters(factory, "created_a_scene", [node_2, 7])


func test_creation_call_orders_between_manual_and_automatic_targets() -> void:
	factory.connect_setup("a_script", "setup")
	factory.created.connect(context.a_function)
	factory.connect("created_a_script", context.another_function)
	var node_1 = factory.create("a_script")
	context.add_child(node_1)
	assert_eq_deep(context.order,
			["another_function_called", "function_called", "script_ready"])

	context.order.clear()
	factory_with_target.connect_setup("a_script", "setup")
	factory_with_target.created.connect(context.a_function)
	factory_with_target.connect("created_a_script", context.another_function)
	factory_with_target.create("a_script")
	assert_eq_deep(context.order,
			["script_ready", "setup", "another_function_called", "function_called"])


func test_create_with_dynamic_data() -> void:
	factory_with_empty_data.setup(factory_data)
	factory_with_empty_data.create_on("a_script", context)
	factory_with_empty_data.create_on("a_scene", context)
	assert_eq_deep(context.order, ["script_ready", "script_ready"])


func test_create_with_dynamic_data_in_parts() -> void:
	factory_with_empty_data.setup_resource("a_script", factory_data["a_script"])
	factory_with_empty_data.create_on("a_script", context)
	assert_eq_deep(context.order, ["script_ready"])
