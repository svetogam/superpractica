#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

class_name ContextualConnector
extends RefCounted

signal agent_added(agent)

const META_NAME := "ContextualConnector"
var agent_group: String
var _context: Node
var _signal_connections: Array = []
var _manual_mode: bool


func _init(p_context: Node, p_agent_group: String, require_manual_registration := false
) -> void:
	_context = p_context
	agent_group = p_agent_group
	_manual_mode = require_manual_registration
	agent_added.connect(_connect_signals_on_new_agent)

	if _manual_mode:
		_add_connector_meta()


func _add_connector_meta() -> void:
	if not _context.has_meta(META_NAME):
		_context.set_meta(META_NAME, {"connectors": []})
	_context.get_meta(META_NAME).connectors.append(self)


func connect_setup(callable: Callable, setup_existing := true) -> void:
	if not _manual_mode:
		_lazy_connect_to_scene_tree()

	if setup_existing:
		for agent in get_agents():
			callable.call(agent)
	agent_added.connect(callable)


func disconnect_setup(callable: Callable) -> void:
	agent_added.disconnect(callable)


func connect_signal(signal_name: String, callable: Callable) -> void:
	if not _manual_mode:
		_lazy_connect_to_scene_tree()

	for agent in get_agents():
		_connect_signal_on_agent(agent, signal_name, callable)
	_add_signal_connection(signal_name, callable)


func disconnect_signal(signal_name: String, callable: Callable) -> void:
	for agent in get_agents():
		_disconnect_signal_on_agent(agent, signal_name, callable)
	_remove_signal_connection(signal_name, callable)


func get_agents() -> Array:
	return ContextUtils.get_children_in_group(_context, agent_group)


func is_agent(node: Node) -> bool:
	return (node != null and node.is_in_group(agent_group)
			and _context.is_ancestor_of(node))


func _lazy_connect_to_scene_tree() -> void:
	if not _is_connected_to_scene_tree():
		_context.get_tree().node_added.connect(_on_node_added)


func _is_connected_to_scene_tree() -> bool:
	for connection in get_incoming_connections():
		if connection.signal.get_object() is SceneTree:
			return true
	return false


func _on_node_added(node: Node) -> void:
	if is_agent(node):
		agent_added.emit(node)


func _add_signal_connection(signal_name: String, callable: Callable) -> void:
	var signal_connection := {"signal_name": signal_name, "callable": callable}
	_signal_connections.append(signal_connection)


func _remove_signal_connection(signal_name: String, callable: Callable) -> void:
	for c in _signal_connections:
		if c.signal_name == signal_name and c.callable == callable:
			_signal_connections.erase(c)
			return


func _connect_signals_on_new_agent(agent: Node) -> void:
	for c in _signal_connections:
		_connect_signal_on_agent(agent, c.signal_name, c.callable)


func _connect_signal_on_agent(agent: Node, signal_name: String, callable: Callable
) -> void:
	agent.connect(signal_name, callable)


func _disconnect_signal_on_agent(agent: Node, signal_name: String, callable: Callable
) -> void:
	agent.disconnect(signal_name, callable)


#====================================================================
# Manual Registration
#====================================================================

static func register(agent: Node) -> void:
	if not agent.is_inside_tree():
		return

	var connectors := _find_contextual_connectors(agent)
	for connector in connectors:
		if agent.is_in_group(connector.agent_group):
			connector.agent_added.emit(agent)


static func _find_contextual_connectors(agent: Node) -> Array:
	var connector_list: Array = []
	for connector_owner in ContextUtils.get_parents_with_meta(agent, META_NAME, true):
		for connector in connector_owner.get_meta(META_NAME).connectors:
			connector_list.append(connector)
	return connector_list
