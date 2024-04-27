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

const ContextScene := preload("a_context.tscn")
const AgentScene := preload("an_agent.tscn")
var context: Node
var agent_1: Node
var agent_2: Node
var agent_3: Node


func before_test():
	context = auto_free(ContextScene.instantiate())
	add_child(context)
	agent_1 = $Context/Agent1
	agent_2 = $Context/Agent2
	agent_3 = $Context/Agent3


func test_find_initial_agents():
	assert_array(context.connector.get_agents()).contains_exactly(
			[agent_1, agent_2, agent_3])
	assert_bool(context.connector.is_agent(agent_1)).is_true()
	assert_bool(context.connector.is_agent(agent_2)).is_true()
	assert_bool(context.connector.is_agent(agent_3)).is_true()


func test_do_not_find_removed_agents():
	context.remove_child(agent_1)
	assert_array(context.connector.get_agents()).contains_exactly([agent_2, agent_3])
	assert_bool(context.connector.is_agent(agent_1)).is_false()
	agent_1.free()

	agent_2.free()
	assert_array(context.connector.get_agents()).contains_exactly([agent_3])

	agent_3.queue_free()
	assert_array(context.connector.get_agents()).contains_exactly([agent_3])
	assert_bool(context.connector.is_agent(agent_3)).is_true()
	await get_tree().process_frame
	assert_array(context.connector.get_agents()).is_empty()


# Causes later tests to unreliably fail
#func test_find_added_agents():
	#monitor_signals(context.connector)
	#var new_agent = auto_free(AgentScene.instantiate())
	#assert_bool(context.connector.is_agent(new_agent)).is_false()
#
	#context.add_child(new_agent)
	#assert_array(context.connector.get_agents()).contains_exactly(
			#[agent_1, agent_2, agent_3, new_agent])
	#assert_bool(context.connector.is_agent(new_agent)).is_true()
	#await assert_signal(context.connector).is_emitted("agent_added", [new_agent])


func test_call_setup():
	assert_array(context.order).contains_exactly(
			["setup of Agent1", "setup of Agent2", "setup of Agent3"])


func test_call_connected_methods():
	context.order.clear()
	agent_1.do_number(1)
	agent_2.do_string("A")
	var new_agent = auto_free(AgentScene.instantiate())
	context.add_child(new_agent)
	new_agent.do_number(2)
	var new_agent_2 = auto_free(AgentScene.instantiate())
	context.add_child(new_agent_2)
	new_agent_2.do_string("B")
	assert_array(context.order).contains_exactly(
			[1, "string: A", "setup of " + new_agent.name, 2,
			"setup of " + new_agent_2.name, "string: B"])


func test_switch_setup_and_setup_with_binds():
	context.order.clear()
	context.switch_setup(5)
	var new_agent = auto_free(AgentScene.instantiate())
	context.add_child(new_agent)
	assert_array(context.order).contains_exactly(["setup with 5"])


func test_do_not_call_disconnected_methods():
	context.order.clear()
	context.ignore_agents()
	agent_1.do_number(1)
	agent_2.do_string("A")
	var new_agent = auto_free(AgentScene.instantiate())
	context.add_child(new_agent)
	new_agent.do_number(2)
	assert_array(context.order).contains_exactly(["setup of " + new_agent.name])
