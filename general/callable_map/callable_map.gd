#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

class_name CallableMap
extends RefCounted

var _callbacks_map := {}


func add(key: String, callable: Callable, one_shot := false) -> void:
	if not _callbacks_map.has(key):
		_callbacks_map[key] = CallableGroup.new()
	_callbacks_map[key].add(callable, one_shot)


func remove(key: String, callable: Callable) -> void:
	_callbacks_map[key].remove(callable)
	if _callbacks_map[key].is_empty():
		_callbacks_map.erase(key)


func call_by_key(key: String, args: Array = []) -> Array:
	if _callbacks_map.has(key):
		return _callbacks_map[key].call_all(args)
	else:
		return []


func has(key: String) -> bool:
	return _callbacks_map.has(key)


func get_keys() -> Array:
	var keys: Array = []
	for key in _callbacks_map.keys():
		assert(key is String)
		keys.append(key)
	return keys


func clear() -> void:
	_callbacks_map.clear()
