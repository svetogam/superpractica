##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name KeyCallbacker
extends RefCounted

var _callbacks_map := {}


func add(key: String, object: Object, method: String, binds:=[], flip_binds:=false,
			one_shot:=false) -> void:
	if not _callbacks_map.has(key):
		_callbacks_map[key] = []
	var callback = _get_callback(object, method, binds, flip_binds, one_shot)
	_callbacks_map[key].append(callback)


func add_one_shot(key: String, object: Object, method: String, binds:=[], flip_binds:=false) -> void:
	add(key, object, method, binds, flip_binds, true)


func remove(key: String, object: Object, method: String) -> void:
	var callback = _get_callback(object, method)
	var callbacks_list = _callbacks_map[key]
	for existing_callback in callbacks_list:
		if _are_callbacks_equal(callback, existing_callback):
			callbacks_list.erase(existing_callback)
			break
	if callbacks_list.is_empty():
		_callbacks_map.erase(key)


func call_callbacks(key: String, args:=[]) -> Array:
	var return_list = []
	var remove_list = []
	if _callbacks_map.has(key):
		var callbacks = _callbacks_map[key]
		for callback in callbacks:
			var result = _call_by_callback(callback, args)
			return_list.append(result)
			if callback.one_shot:
				remove_list.append(callback)

	for callback in remove_list:
		remove(key, instance_from_id(callback.object_id), callback.method)

	return return_list


func do_callbacks_return_true(key: String, args:=[]) -> bool:
	var results = call_callbacks(key, args)
	return _are_all_results_same(results, true)


func do_callbacks_return_false(key: String, args:=[]) -> bool:
	var results = call_callbacks(key, args)
	return _are_all_results_same(results, false)


func _are_all_results_same(results: Array, sought: bool) -> bool:
	for result in results:
		if result != sought:
			return false
	return true


func has(key: String) -> bool:
	return _callbacks_map.has(key)


func get_keys() -> Array:
	return _callbacks_map.keys()


func clear() -> void:
	_callbacks_map.clear()


func _get_callback(object: Object, method: String, binds:=[], flip_binds:=false,
			one_shot:=false) -> Dictionary:
	return {"object_id": object.get_instance_id(), "method": method,
			"binds": binds, "flip_binds": flip_binds, "one_shot": one_shot}


func _call_by_callback(callback: Dictionary, p_args:=[]):
	var object = instance_from_id(callback.object_id)
	var args
	if callback.flip_binds:
		args = callback.binds + p_args
	else:
		args = p_args + callback.binds
	return object.callv(callback.method, args)


func _are_callbacks_equal(callback_1: Dictionary, callback_2: Dictionary) -> bool:
	return callback_1.object_id == callback_2.object_id and callback_1.method == callback_2.method
