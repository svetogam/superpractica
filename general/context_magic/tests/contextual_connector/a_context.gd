##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

extends Node

const GROUP = "test_agent_group"
var connector := ContextualConnector.new(self, GROUP)
var order := []


func _ready() -> void:
	connector.connect_setup(self, "_agent_setup")
	connector.connect_signal("number_done", self, "_on_agent_number_done")
	connector.connect_signal("string_done", self, "_on_agent_string_done", ["string: "])


func switch_setup(number: int) -> void:
	connector.disconnect_setup(self, "_agent_setup")
	connector.connect_setup(self, "_agent_setup_with_number", [number], false)


func ignore_agents() -> void:
	connector.disconnect_signal("number_done", self, "_on_agent_number_done")
	connector.disconnect_signal("string_done", self, "_on_agent_string_done")


func _agent_setup(agent: Node) -> void:
	agent.was_setup = true
	order.append("setup of " + agent.name)


func _agent_setup_with_number(agent: Node, number: int) -> void:
	agent.was_setup = true
	order.append("setup with " + str(number))


func _on_agent_number_done(number: int) -> void:
	order.append(number)


func _on_agent_string_done(string: String, bound_string: String) -> void:
	order.append(bound_string + string)
