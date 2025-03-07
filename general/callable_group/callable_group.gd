# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

class_name CallableGroup
extends RefCounted

var _callable_list: Array = []
var _one_shot_callable_list: Array = []


func add(callable: Callable, one_shot := false) -> void:
	if not one_shot:
		_callable_list.append(callable)
	else:
		_one_shot_callable_list.append(callable)


func remove(callable: Callable) -> void:
	for existing_callable in _one_shot_callable_list:
		if _callables_are_equal(callable, existing_callable):
			_one_shot_callable_list.erase(existing_callable)
			return
	for existing_callable in _callable_list:
		if _callables_are_equal(callable, existing_callable):
			_callable_list.erase(existing_callable)
			return


func call_all(args: Array = []) -> Array:
	var result_list: Array = []
	for callable in _callable_list + _one_shot_callable_list:
		var result = callable.callv(args)
		result_list.append(result)
	_one_shot_callable_list.clear()
	return result_list


func clear() -> void:
	_callable_list.clear()
	_one_shot_callable_list.clear()


func is_empty() -> bool:
	return _callable_list.is_empty() and _one_shot_callable_list.is_empty()


# This works when c_1 == c_2 sometimes doesn't
func _callables_are_equal(c_1: Callable, c_2: Callable) -> bool:
	return (c_1.is_valid() and c_2.is_valid()
			and c_1.get_object_id() == c_2.get_object_id()
			and c_1.get_method() == c_2.get_method())
