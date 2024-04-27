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

const TestScene := preload("contextual_locator_test_scene.tscn")
const AgentScript := preload("an_agent.gd")
const ServiceScript := preload("a_service.gd")
var scene: Node


func before_test():
	scene = auto_free(TestScene.instantiate())
	add_child(scene)


#====================================================================
# Static
#====================================================================

func test_agents_find_registered_values():
	ContextualLocator.register($Top/Context, "a", 1)
	ContextualLocator.register($Top/Context, "b", "wow")
	assert_int(ContextualLocator.find($Top/Context/Agent1, "a")).is_equal(1)
	assert_str(ContextualLocator.find($Top/Context/Agent1, "b")).is_equal("wow")

	var new_node = auto_free(Node.new())
	$Top/Context.add_child(new_node)
	ContextualLocator.register($Top/Context, "c", new_node)
	var found_node = ContextualLocator.find($Top/Context/Agent1, "c")
	assert_int(found_node.get_instance_id()).is_equal(new_node.get_instance_id())


func test_only_subnodes_and_self_find_the_context():
	ContextualLocator.register($Top/Context, "a", 1)
	var new_agent_1 = auto_free(AgentScript.new())
	$Top/Context.add_child(new_agent_1)
	var new_agent_2 = auto_free(AgentScript.new())
	$Top.add_child(new_agent_2)

	assert_int(ContextualLocator.find($Top/Context/Agent1, "a")).is_equal(1)
	assert_int(ContextualLocator.find($Top/Context/Subcontext/SubAgent1, "a")).is_equal(1)
	assert_int(ContextualLocator.find(new_agent_1, "a")).is_equal(1)
	assert_int(ContextualLocator.find($Top/Context, "a")).is_equal(1)

	assert_that(ContextualLocator.find($Top/ContextWithServices/Agent1, "a")).is_null()
	assert_that(ContextualLocator.find(
			$Top/ContextWithServices/Subcontext/SubAgent1, "a")).is_null()
	assert_that(ContextualLocator.find($Top/AgentWithoutContext, "a")).is_null()
	assert_that(ContextualLocator.find(new_agent_2, "a")).is_null()
	assert_that(ContextualLocator.find($Top, "a")).is_null()


func test_subcontexts_override_contexts_unless_flagged():
	ContextualLocator.register($Top/Context, "a", 1)
	ContextualLocator.register($Top/Context, "b", 2)
	ContextualLocator.register($Top/Context/Subcontext, "a", 3)
	ContextualLocator.register($Top/Context/Subcontext, "b", 4, false)
	assert_int(ContextualLocator.find($Top/Context/Subcontext/SubAgent1, "a")).is_equal(3)
	assert_int(ContextualLocator.find($Top/Context/Subcontext/SubAgent1, "b")).is_equal(2)


func test_agents_do_not_find_unregistered_values():
	ContextualLocator.register($Top/Context, "a", 1)
	ContextualLocator.unregister($Top/Context, "a")
	assert_that(ContextualLocator.find($Top/Context/Agent1, "a")).is_null()
	assert_that(ContextualLocator.find($Top/Context/Agent1, "b")).is_null()


func test_reregistering_overwrites():
	ContextualLocator.register($Top/Context, "a", 1)
	ContextualLocator.register($Top/Context, "a", 2)
	assert_int(ContextualLocator.find($Top/Context/Agent1, "a")).is_equal(2)


func test_agents_find_registered_properties():
	var context := $Top/Context
	var agent := $Top/Context/Agent1
	ContextualLocator.register_property(context, "property_1")
	ContextualLocator.register_property_as(context, "property_2", "my_property")
	assert_that(ContextualLocator.find(agent, "property_1")).is_equal(
			context.INITIAL_PROPERTY_1)
	assert_that(ContextualLocator.find(agent, "property_2")).is_null()
	assert_that(ContextualLocator.find(agent, "my_property")).is_equal(
			context.INITIAL_PROPERTY_2)

	context.property_1 = 34
	context.property_2 = "wow"
	assert_that(ContextualLocator.find(agent, "property_1")).is_equal(34)
	assert_that(ContextualLocator.find(agent, "property_2")).is_null()
	assert_that(ContextualLocator.find(agent, "my_property")).is_equal("wow")


func test_agents_find_registered_getters():
	var context := $Top/Context
	var agent := $Top/Context/Agent1
	ContextualLocator.register_getter(context.property_1_getter, "a")
	ContextualLocator.register_getter(context.property_2_getter, "b")
	assert_that(ContextualLocator.find(agent, "a")).is_equal(context.INITIAL_PROPERTY_1)
	assert_that(ContextualLocator.find(agent, "b")).is_equal(context.INITIAL_PROPERTY_2)

	context.property_1 = 34
	context.property_2 = "wow"
	assert_that(ContextualLocator.find(agent, "a")).is_equal(34)
	assert_that(ContextualLocator.find(agent, "b")).is_equal("wow")


func test_agents_find_registered_nodes_by_group():
	var context = auto_free($Top/ContextWithServices)
	var agent = auto_free($Top/ContextWithServices/Agent1)
	var service_1 = auto_free($Top/ContextWithServices/Service1)
	var service_2 = auto_free($Top/ContextWithServices/Service2)
	ContextualLocator.register_child_by_group(context, "a_group_1")
	ContextualLocator.register_child_by_group(context, "a_group_2")
	var found_1 = ContextualLocator.find(agent, "a_group_1")
	var found_2 = ContextualLocator.find(agent, "a_group_2")
	assert_that(found_1).is_not_null()
	assert_that(found_2).is_not_null()
	if found_1 != null:
		assert_int(found_1.get_instance_id()).is_equal(service_1.get_instance_id())
	if found_2 != null:
		assert_int(found_2.get_instance_id()).is_equal(service_2.get_instance_id())

	var new_service = auto_free(ServiceScript.new())
	context.remove_child(service_1)
	context.add_child(new_service)
	var found_3 = ContextualLocator.find(agent, "a_group_1")
	assert_that(found_3).is_not_null()
	if found_3 != null:
		assert_int(found_3.get_instance_id()).is_equal(new_service.get_instance_id())


func test_agents_do_not_find_by_group_if_not_exactly_one_is_in_group():
	var context := $Top/ContextWithServices
	var agent := $Top/ContextWithServices/Agent1
	ContextualLocator.register_child_by_group(context, "not_an_actual_group")
	assert_that(ContextualLocator.find(agent, "not_an_actual_group")).is_null()

	ContextualLocator.register_child_by_group(context, "duplicate_group")
	assert_that(ContextualLocator.find(agent, "duplicate_group")).is_null()


#====================================================================
# Auto Signal
#====================================================================

func test_auto_signal_signals_immediately_if_already_registered():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	monitor_signals(agent.locator)
	ContextualLocator.register($Top/Context, "a", 1)
	agent.locator.auto_signal("a")
	await assert_signal(agent.locator).is_emitted("auto_found", ["a", 1])


func test_auto_signal_signals_upon_registration_if_not_registered():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	monitor_signals(agent.locator)
	agent.locator.auto_signal("a")
	await assert_signal(agent.locator).wait_until(50).is_not_emitted("auto_found")

	ContextualLocator.register($Top/Context, "a", 1)
	await assert_signal(agent.locator).is_emitted("auto_found", ["a", 1])


# Test is broken in this form.
#func test_auto_signal_signals_once_on_registration_unless_flagged():
	#var agent_1 := $Top/Context/Agent1
	#var agent_2 := $Top/Context/Agent2
	#var agent_3 := $Top/Context/Agent3
	#agent_1.locator = ContextualLocator.new(agent_1)
	#agent_2.locator = ContextualLocator.new(agent_2, true)
	#agent_3.locator = ContextualLocator.new(agent_3, true)
	#monitor_signals(agent_1.locator)
	#monitor_signals(agent_2.locator)
	#monitor_signals(agent_3.locator)
#
	#agent_1.locator.auto_signal("a")
	#agent_2.locator.auto_signal("a")
	#ContextualLocator.register($Top/Context, "a", 1)
	#agent_3.locator.auto_signal("a")
	#await assert_signal(agent_1.locator).is_emitted("auto_found") # Should be emitted once
	#await assert_signal(agent_2.locator).is_emitted("auto_found") # Should be emitted once
	#await assert_signal(agent_3.locator).is_emitted("auto_found") # Should be emitted once
#
	#ContextualLocator.register($Top/Context, "a", 2)
	#await assert_signal(agent_1.locator).is_emitted("auto_found") # Should be emitted once
	#await assert_signal(agent_2.locator).is_emitted("auto_found") # Should be emitted twice
	#await assert_signal(agent_3.locator).is_emitted("auto_found") # Should be emitted twice


func test_auto_signal_does_not_react_to_unregistration():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent, true)
	monitor_signals(agent.locator)
	agent.locator.auto_signal("a")
	ContextualLocator.register($Top/Context, "a", 4)
	ContextualLocator.unregister($Top/Context, "a")
	await assert_signal(agent.locator).wait_until(50).is_not_emitted("auto_found")


func test_can_have_multiple_auto_signals():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	monitor_signals(agent.locator)
	agent.locator.auto_signal("a")
	agent.locator.auto_signal("c")
	agent.locator.auto_signal("b")
	ContextualLocator.register($Top/Context, "a", 4)
	await assert_signal(agent.locator).is_emitted("auto_found", ["a", 4])

	ContextualLocator.register($Top/Context, "b", 5)
	await assert_signal(agent.locator).is_emitted("auto_found", ["b", 5])

	ContextualLocator.register($Top/Context, "c", 6)
	await assert_signal(agent.locator).is_emitted("auto_found", ["c", 6])


func test_removing_agent_stops_signals_connected_to_other_objects():
	var agent_1 := $Top/Context/Agent1
	var agent_2 := $Top/Context/Agent2
	var agent_3 := $Top/Context/Agent3
	agent_1.locator = ContextualLocator.new(agent_2)
	agent_1.locator.auto_signal("a")
	agent_1.locator.auto_found.connect(agent_3.auto_callback)
	agent_2.free()
	ContextualLocator.register($Top/Context, "a", 1)
	assert_that(agent_3.value).is_equal(AgentScript.INITIAL_VALUE)


#====================================================================
# Auto Callback
#====================================================================

func test_auto_callback_is_called_immediately_if_already_registered():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	ContextualLocator.register($Top/Context, "a", 1)
	agent.locator.auto_callback("a", agent.auto_callback)
	assert_array(agent.event_order).contains_exactly(["auto_callback"])
	assert_that(agent.value).is_equal(1)


func test_auto_callback_is_called_upon_registration_if_not_registered():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	agent.locator.auto_callback("a", agent.auto_callback)
	assert_array(agent.event_order).is_empty()
	assert_that(agent.value).is_equal(agent.INITIAL_VALUE)

	ContextualLocator.register($Top/Context, "a", 1)
	assert_array(agent.event_order).contains_exactly(["auto_callback"])
	assert_that(agent.value).is_equal(1)


func test_auto_found_is_emitted_after_auto_callback():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	monitor_signals(agent.locator)
	agent.locator.auto_callback("a", agent.auto_callback)
	agent.locator.auto_found.connect(agent.auto_callback_2)
	ContextualLocator.register($Top/Context, "a", 1)
	await assert_signal(agent.locator).is_emitted("auto_found", ["a", 1])
	assert_array(agent.event_order).contains_exactly(["auto_callback", "auto_callback_2"])


func test_auto_callback_is_called_once_on_registration_unless_flagged():
	var agent_1 := $Top/Context/Agent1
	var agent_2 := $Top/Context/Agent2
	var agent_3 := $Top/Context/Agent3
	agent_1.locator = ContextualLocator.new(agent_1)
	agent_2.locator = ContextualLocator.new(agent_2, true)
	agent_3.locator = ContextualLocator.new(agent_3, true)
	agent_1.locator.auto_callback("a", agent_1.auto_callback)
	agent_2.locator.auto_callback("a", agent_2.auto_callback)
	ContextualLocator.register($Top/Context, "a", 1)
	agent_3.locator.auto_callback("a", agent_3.auto_callback)
	assert_array(agent_1.event_order).contains_exactly(["auto_callback"])
	assert_array(agent_2.event_order).contains_exactly(["auto_callback"])
	assert_array(agent_3.event_order).contains_exactly(["auto_callback"])
	assert_that(agent_1.value).is_equal(1)
	assert_that(agent_2.value).is_equal(1)
	assert_that(agent_3.value).is_equal(1)

	ContextualLocator.register($Top/Context, "a", 2)
	assert_array(agent_1.event_order).contains_exactly(["auto_callback"])
	assert_array(agent_2.event_order).contains_exactly(["auto_callback", "auto_callback"])
	assert_array(agent_3.event_order).contains_exactly(["auto_callback", "auto_callback"])
	assert_that(agent_1.value).is_equal(1)
	assert_that(agent_2.value).is_equal(2)
	assert_that(agent_3.value).is_equal(2)


func test_auto_callbacks_are_only_called_on_registration():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent, true)
	agent.locator.auto_callback("a", agent.auto_callback)
	ContextualLocator.register($Top/Context, "a", 1)
	agent.locator.auto_callback("a", agent.auto_callback_2)
	ContextualLocator.register($Top/Context, "a", 2)
	assert_array(agent.event_order).contains_exactly(
			["auto_callback", "auto_callback_2", "auto_callback", "auto_callback_2"])


func test_auto_callback_does_not_react_to_unregistration():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent, true)
	agent.locator.auto_callback("a", agent.auto_callback)
	ContextualLocator.register($Top/Context, "a", 1)
	ContextualLocator.unregister($Top/Context, "a")
	assert_array(agent.event_order).contains_exactly(["auto_callback"])
	assert_that(agent.value).is_equal(1)


func test_auto_callback_accepts_extra_parameters():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	ContextualLocator.register($Top/Context, "a", 1)
	agent.locator.auto_callback("a", agent.auto_callback.bind(5))
	assert_array(agent.event_order).contains_exactly(["auto_callback"])
	assert_that(agent.value).is_equal(1)
	assert_that(agent.last_given_arg).is_equal(5)


func test_can_have_multiple_auto_callbacks():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	agent.locator.auto_callback("a", agent.auto_callback)
	agent.locator.auto_callback("c", agent.auto_callback_3)
	agent.locator.auto_callback("b", agent.auto_callback_2)
	ContextualLocator.register($Top/Context, "a", 4)
	ContextualLocator.register($Top/Context, "b", 5)
	ContextualLocator.register($Top/Context, "c", 6)
	assert_array(agent.event_order).contains_exactly(
			["auto_callback", "auto_callback_2", "auto_callback_3"])
	assert_that(agent.value).is_equal(4)
	assert_that(agent.value_2).is_equal(5)
	assert_that(agent.value_3).is_equal(6)


func test_can_connect_same_auto_callback_to_multiple_keys():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	agent.locator.auto_callback("a", agent.auto_callback.bind(4))
	agent.locator.auto_callback("b", agent.auto_callback.bind(5))
	agent.locator.auto_callback("c", agent.auto_callback.bind(6))
	ContextualLocator.register($Top/Context, "a", 1)
	assert_array(agent.event_order).contains_exactly(["auto_callback"])
	assert_that(agent.value).is_equal(1)
	assert_that(agent.last_given_arg).is_equal(4)

	ContextualLocator.register($Top/Context, "c", 3)
	assert_array(agent.event_order).contains_exactly(["auto_callback", "auto_callback"])
	assert_that(agent.value).is_equal(3)
	assert_that(agent.last_given_arg).is_equal(6)

	ContextualLocator.register($Top/Context, "b", 2)
	assert_array(agent.event_order).contains_exactly(
			["auto_callback", "auto_callback", "auto_callback"])
	assert_that(agent.value).is_equal(2)
	assert_that(agent.last_given_arg).is_equal(5)


func test_can_connect_multiple_auto_callbacks_to_same_key():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	agent.locator.auto_callback("a", agent.auto_callback.bind(4))
	agent.locator.auto_callback("a", agent.auto_callback_2.bind(5))
	ContextualLocator.register($Top/Context, "a", 1)
	assert_array(agent.event_order).contains_exactly(["auto_callback", "auto_callback_2"])
	assert_that(agent.value).is_equal(1)
	assert_that(agent.value_2).is_equal(1)
	assert_that(agent.last_given_arg).is_equal(5)


func test_auto_callback_can_be_on_another_object():
	var agent_1 := $Top/Context/Agent1
	var agent_2 := $Top/Context/Agent2
	agent_1.locator = ContextualLocator.new(agent_1)
	agent_1.locator.auto_callback("a", agent_2.auto_callback)
	ContextualLocator.register($Top/Context, "a", 1)
	assert_that(agent_1.value).is_equal(agent_1.INITIAL_VALUE)
	assert_that(agent_2.value).is_equal(1)


func test_auto_callback_can_be_on_multiple_objects_with_same_method_name():
	var agent_1 := $Top/Context/Agent1
	var agent_2 := $Top/Context/Agent2
	agent_1.locator = ContextualLocator.new(agent_1)
	agent_1.locator.auto_callback("b", agent_1.auto_callback)
	agent_1.locator.auto_callback("b", agent_2.auto_callback)
	ContextualLocator.register($Top/Context, "b", 2)
	assert_that(agent_1.value).is_equal(2)
	assert_that(agent_2.value).is_equal(2)


func test_removing_agent_stops_callbacks_on_other_objects():
	var agent_1 := $Top/Context/Agent1
	var agent_2 := $Top/Context/Agent2
	agent_1.locator = ContextualLocator.new(agent_1)
	agent_1.locator.auto_callback("a", agent_2.auto_callback)
	agent_1.free()
	ContextualLocator.register($Top/Context, "a", 1)
	assert_that(agent_2.value).is_equal(AgentScript.INITIAL_VALUE)


#====================================================================
# Auto Set
#====================================================================

func test_auto_set_sets_immediately_if_already_registered():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	ContextualLocator.register($Top/Context, "a", 1)
	agent.locator.auto_set("a", "value")
	assert_that(agent.value).is_equal(1)


func test_auto_set_sets_upon_registration_if_not_registered():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	agent.locator.auto_set("a", "value")
	assert_that(agent.value).is_equal(agent.INITIAL_VALUE)

	ContextualLocator.register($Top/Context, "a", 1)
	assert_that(agent.value).is_equal(1)


func test_auto_found_is_emitted_after_auto_set():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	monitor_signals(agent.locator)
	agent.locator.auto_set("a", "value_2")
	agent.locator.auto_found.connect(agent.copy_value_2_to_value_3)
	ContextualLocator.register($Top/Context, "a", 1)
	await assert_signal(agent.locator).is_emitted("auto_found", ["a", 1])
	assert_that(agent.value_2).is_equal(1)
	assert_that(agent.value_3).is_equal(1)


func test_auto_set_sets_once_on_registration_unless_flagged():
	var agent_1 := $Top/Context/Agent1
	var agent_2 := $Top/Context/Agent2
	var agent_3 := $Top/Context/Agent3
	agent_1.locator = ContextualLocator.new(agent_1)
	agent_2.locator = ContextualLocator.new(agent_2, true)
	agent_3.locator = ContextualLocator.new(agent_3, true)
	agent_1.locator.auto_set("a", "value")
	agent_2.locator.auto_set("a", "value")
	ContextualLocator.register($Top/Context, "a", 5)
	agent_3.locator.auto_set("a", "value")
	assert_that(agent_1.value).is_equal(5)
	assert_that(agent_2.value).is_equal(5)
	assert_that(agent_3.value).is_equal(5)

	ContextualLocator.register($Top/Context, "a", 6)
	assert_that(agent_1.value).is_equal(5)
	assert_that(agent_2.value).is_equal(6)
	assert_that(agent_3.value).is_equal(6)


func test_auto_set_does_not_react_to_unregistration():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent, true)
	agent.locator.auto_set("a", "value")
	ContextualLocator.register($Top/Context, "a", 1)
	ContextualLocator.unregister($Top/Context, "a")
	assert_that(agent.value).is_equal(1)


func test_can_have_multiple_auto_sets():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	agent.locator.auto_set("a", "value")
	agent.locator.auto_set("c", "value_3")
	agent.locator.auto_set("b", "value_2")
	ContextualLocator.register($Top/Context, "a", 4)
	ContextualLocator.register($Top/Context, "b", 5)
	ContextualLocator.register($Top/Context, "c", 6)
	assert_that(agent.value).is_equal(4)
	assert_that(agent.value_2).is_equal(5)
	assert_that(agent.value_3).is_equal(6)


func test_can_have_multiple_auto_sets_on_same_property():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	agent.locator.auto_set("a", "value")
	agent.locator.auto_set("b", "value")
	agent.locator.auto_set("c", "value")
	ContextualLocator.register($Top/Context, "a", 1)
	assert_that(agent.value).is_equal(1)

	ContextualLocator.register($Top/Context, "c", 3)
	assert_that(agent.value).is_equal(3)

	ContextualLocator.register($Top/Context, "b", 2)
	assert_that(agent.value).is_equal(2)


func test_can_auto_set_multiple_properties_by_one_key():
	var agent := $Top/Context/Agent1
	agent.locator = ContextualLocator.new(agent)
	agent.locator.auto_set("a", "value")
	agent.locator.auto_set("a", "value_2")
	ContextualLocator.register($Top/Context, "a", 1)
	assert_that(agent.value).is_equal(1)
	assert_that(agent.value_2).is_equal(1)
