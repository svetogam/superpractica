##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name ContextualLocator
extends RefCounted

const META_PREFIX := "ContextualLocator_"
const SCENE_TREE_SIGNAL_PREFIX := "__signal_to_contextual_locator_that_this_was_registered:"


static func register(context: Node, key: String, value, override_parents:=true) -> void:
	var meta_key = META_PREFIX + key
	context.set_meta(meta_key, {"value": value, "override_parents": override_parents})
	_emit_key_registered_signal(context.get_tree(), key)


static func register_property(context: Node, property_name: String,
			override_parents:=true) -> void:
	register_property_as(context, property_name, property_name, override_parents)


static func register_property_as(context: Node, property_name: String, key: String,
			override_parents:=true) -> void:
	var meta_key = META_PREFIX + key
	context.set_meta(meta_key,
			{"property_name": property_name, "override_parents": override_parents})
	_emit_key_registered_signal(context.get_tree(), key)


static func register_getter(context: Node, key: String, method_name: String,
			override_parents:=true) -> void:
	var meta_key = META_PREFIX + key
	context.set_meta(meta_key, {"method_name": method_name, "override_parents": override_parents})
	_emit_key_registered_signal(context.get_tree(), key)


static func register_child_by_group(context: Node, group: String,
			override_parents:=true) -> void:
	register_child_by_group_as(context, group, group, override_parents)


static func register_child_by_group_as(context: Node, group: String, key: String,
			override_parents:=true) -> void:
	var meta_key = META_PREFIX + key
	context.set_meta(meta_key, {"group": group, "override_parents": override_parents})
	if ContextUtils.get_only_child_in_group(context, group) != null:
		_emit_key_registered_signal(context.get_tree(), key)


static func _emit_key_registered_signal(tree: SceneTree, key: String) -> void:
	var signal_name = _get_scene_tree_signal_name(key)
	if tree.has_user_signal(signal_name):
		tree.emit_signal(signal_name)


static func unregister(context: Node, key: String) -> void:
	var meta_key = META_PREFIX + key
	context.remove_meta(meta_key)


static func find(agent: Node, key: String):
	var meta_key = META_PREFIX + key
	var context = _get_context_for_meta(agent, meta_key)
	if context != null:
		return _get_value_by_meta_key(context, meta_key)
	return null


static func _get_context_for_meta(agent: Node, meta_key: String) -> Node:
	var context_list = ContextUtils.get_parents_with_meta(agent, meta_key, true)
	for context in context_list:
		var meta_dict = context.get_meta(meta_key)
		if meta_dict["override_parents"]:
			return context
	if context_list.is_empty():
		return null
	else:
		return context_list[-1]


static func _get_value_by_meta_key(node: Node, meta_key: String):
	var meta_dict = node.get_meta(meta_key)
	if meta_dict.has("value"):
		return meta_dict["value"]
	elif meta_dict.has("property_name"):
		var property_name = meta_dict["property_name"]
		return node.get(property_name)
	elif meta_dict.has("method_name"):
		var method_name = meta_dict["method_name"]
		return node.call(method_name)
	elif meta_dict.has("group"):
		var group = meta_dict["group"]
		return ContextUtils.get_only_child_in_group(node, group)


static func _initialize_scene_tree_signal_for_key(tree: SceneTree, key: String) -> String:
	var signal_name = _get_scene_tree_signal_name(key)
	if not tree.has_user_signal(signal_name):
		tree.add_user_signal(signal_name)
	return signal_name


static func _get_scene_tree_signal_name(key: String) -> String:
	return SCENE_TREE_SIGNAL_PREFIX + key


#####################################################################
# Instance Interface
#####################################################################

signal auto_found(key, value)

var _agent: Node
var _continuous_update_mode: bool
var _callbacker := KeyCallbacker.new()


func _init(p_agent: Node, update_after_found:=false) -> void:
	_agent = p_agent
	_continuous_update_mode = update_after_found
	_agent.tree_exiting.connect(_on_agent_exiting_tree)


func _on_agent_exiting_tree() -> void:
	_callbacker.clear()
	var connections = get_incoming_connections()
	for connection in connections:
		connection.signal.disconnect(connection.callable)


func auto_signal(key: String) -> void:
	var value = find(_agent, key)
	if value != null:
		auto_found.emit(key, value)
		if not _continuous_update_mode:
			_stop_auto_signal(key)

	if value == null or _continuous_update_mode:
		_connect_auto_signal(key)


func _connect_auto_signal(key: String) -> void:
	var signal_name = _initialize_scene_tree_signal_for_key(_agent.get_tree(), key)
	if not _agent.get_tree().is_connected(signal_name, auto_signal):
		_agent.get_tree().connect(signal_name, auto_signal.bind(key))


func _stop_auto_signal(key: String) -> void:
	var signal_name = _get_scene_tree_signal_name(key)
	if _agent.get_tree().has_signal(signal_name)\
				and _agent.get_tree().is_connected(signal_name, auto_signal):
		_agent.get_tree().disconnect(signal_name, auto_signal)


func auto_callback(key: String, object: Object, method: String, binds:=[]) -> void:
	var value = find(_agent, key)
	if value != null:
		var args = [value] + binds
		_agent.callv(method, args)
		auto_found.emit(key, value)
		if not _continuous_update_mode:
			_stop_auto_callbacks(key)

	if value == null or _continuous_update_mode:
		_connect_auto_callback(key, object, method, binds)


func _connect_auto_callback(key: String, object: Object, method: String, binds:=[]) -> void:
	_callbacker.add(key, object, method, binds, false, not _continuous_update_mode)
	var signal_name = _initialize_scene_tree_signal_for_key(_agent.get_tree(), key)
	if not _agent.get_tree().is_connected(signal_name, _try_auto_callbacks):
		_agent.get_tree().connect(signal_name, _try_auto_callbacks.bind(key))


func _stop_auto_callbacks(key: String) -> void:
	if not _callbacker.has(key):
		var signal_name = _get_scene_tree_signal_name(key)
		if _agent.get_tree().has_signal(signal_name)\
					and _agent.get_tree().is_connected(signal_name, _try_auto_callbacks):
			_agent.get_tree().disconnect(signal_name, _try_auto_callbacks)


func _try_auto_callbacks(key: String) -> bool:
	var value = find(_agent, key)
	if value != null:
		_callbacker.call_callbacks(key, [value])
		auto_found.emit(key, value)
		return true
	return false


func auto_set(key: String, property_name: String) -> void:
	var value = find(_agent, key)
	if value != null:
		_agent.set(property_name, value)
		auto_found.emit(key, value)
		if not _continuous_update_mode:
			_stop_auto_callbacks(key)

	if value == null or _continuous_update_mode:
		_connect_auto_set(key, property_name)


func _connect_auto_set(key: String, property_name: String) -> void:
	_callbacker.add(key, _agent, "set", [property_name], true, not _continuous_update_mode)
	var signal_name = _initialize_scene_tree_signal_for_key(_agent.get_tree(), key)
	if not _agent.get_tree().is_connected(signal_name, _try_auto_callbacks):
		_agent.get_tree().connect(signal_name, _try_auto_callbacks.bind(key))
