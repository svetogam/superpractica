##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name NodeFactory
extends Node

signal created #(key, node, ...)
#signals created_my_key(node, ...)

@export var _initial_data: GDScript
@export var _target: Node
var _data := {}
var _setups_map := {}


func _ready() -> void:
	if _initial_data != null:
		setup(_initial_data.get_data())


func setup(p_data: Dictionary) -> void:
	_data = p_data
	for key in _data.keys():
		_add_dynamic_signal(key)
		_setups_map[key] = []


func setup_resource(key, resource: Resource) -> void:
	assert(not _data.keys().has(key))
	_data[key] = resource
	_add_dynamic_signal(key)
	_setups_map[key] = []


func create(key, args:=[]) -> Node:
	return create_on(key, _target, args)


func create_on(key, p_target: Node, args:=[]) -> Node:
	var node = _make_node(key)

	if p_target != null:
		p_target.add_child(node)

	_call_setups(key, node, args)
	_emit_dynamic_signal(key, node, args)
	_emit_static_signal(key, node, args)

	return node


func _make_node(key) -> Node:
	var resource = _data[key]
	if resource is GDScript:
		return resource.new()
	elif resource is PackedScene:
		return resource.instantiate()
	else:
		assert(false)
		return null


func _call_setups(key, node: Node, args: Array) -> void:
	if _setups_map.has(key):
		var setup_funcs = _setups_map[key]
		for setup_func in setup_funcs:
			node.callv(setup_func.method, args + setup_func.binds)


func _emit_dynamic_signal(key, node: Node, p_args:=[]) -> void:
	var signal_name = _get_dynamic_signal_name(key)
	var args = [node] + p_args
	Utils.emit_signal_v(self, signal_name, args)


func _emit_static_signal(key, node: Node, p_args:=[]) -> void:
	var args = [key, node] + p_args
	Utils.emit_signal_v(self, "created", args)


func connect_setup(key, setup_method: String, binds:=[]) -> void:
	var setup_func = {"method": setup_method, "binds": binds}
	_setups_map[key].append(setup_func)


func disconnect_setup(key, setup_method: String) -> void:
	var setup_funcs = _setups_map[key]
	for setup_func in setup_funcs:
		if setup_func.method == setup_method:
			_setups_map[key].erase(setup_func)
			return


func connect_setup_on_all(setup_method: String, binds:=[]) -> void:
	for key in _data.keys():
		connect_setup(key, setup_method, binds)


func disconnect_setup_on_all(setup_method: String) -> void:
	for key in _data.keys():
		disconnect_setup(key, setup_method)


func _add_dynamic_signal(key) -> void:
	var signal_name = _get_dynamic_signal_name(key)
	add_user_signal(signal_name)


func _get_dynamic_signal_name(key) -> String:
	if key is String:
		return "created_" + key
	else:
		return "created_" + str(key)
