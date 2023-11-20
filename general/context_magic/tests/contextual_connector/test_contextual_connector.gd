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
const AgentScene := preload("an_agent.tscn")
var context: Node
var agent_1: Node
var agent_2: Node
var agent_3: Node


func before_each():
	context = ContextScene.instantiate()
	add_child(context)
	agent_1 = $Context/Agent1
	agent_2 = $Context/Agent2
	agent_3 = $Context/Agent3


func after_each():
	remove_child(context)
	context.queue_free()


func test_find_initial_agents():
	assert_eq_deep(context.connector.get_agents(), [agent_1, agent_2, agent_3])
	assert_true(context.connector.is_agent(agent_1))
	assert_true(context.connector.is_agent(agent_2))
	assert_true(context.connector.is_agent(agent_3))


func test_do_not_find_removed_agents():
	context.remove_child(agent_1)
	assert_eq_deep(context.connector.get_agents(), [agent_2, agent_3])
	assert_true(not context.connector.is_agent(agent_1))

	agent_2.free()
	assert_eq_deep(context.connector.get_agents(), [agent_3])

	agent_3.queue_free()
	assert_eq_deep(context.connector.get_agents(), [agent_3])
	assert_true(context.connector.is_agent(agent_3))
	await get_tree().process_frame
	assert_eq_deep(context.connector.get_agents(), [])


func test_find_added_agents():
	watch_signals(context.connector)
	var new_agent = AgentScene.instantiate()
	assert_false(context.connector.is_agent(new_agent))
	assert_signal_not_emitted(context.connector, "agent_added")

	context.add_child(new_agent)
	assert_eq_deep(context.connector.get_agents(), [agent_1, agent_2, agent_3, new_agent])
	assert_true(context.connector.is_agent(new_agent))
	assert_signal_emitted_with_parameters(context.connector, "agent_added", [new_agent])


func test_call_setup():
	assert_eq_deep(context.order, ["setup of Agent1", "setup of Agent2", "setup of Agent3"])


func test_call_connected_methods():
	context.order.clear()
	agent_1.do_number(1)
	agent_2.do_string("A")
	var new_agent = AgentScene.instantiate()
	context.add_child(new_agent)
	new_agent.do_number(2)
	var new_agent_2 = AgentScene.instantiate()
	context.add_child(new_agent_2)
	new_agent_2.do_string("B")
	assert_eq_deep(context.order,
			[1, "string: A", "setup of " + new_agent.name, 2,
			"setup of " + new_agent_2.name, "string: B"])


func test_switch_setup_and_setup_with_binds():
	context.order.clear()
	context.switch_setup(5)
	var new_agent = AgentScene.instantiate()
	context.add_child(new_agent)
	assert_eq_deep(context.order, ["setup with 5"])


func test_do_not_call_disconnected_methods():
	context.order.clear()
	context.ignore_agents()
	agent_1.do_number(1)
	agent_2.do_string("A")
	var new_agent = AgentScene.instantiate()
	context.add_child(new_agent)
	new_agent.do_number(2)
	assert_eq_deep(context.order, ["setup of " + new_agent.name])
