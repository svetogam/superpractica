#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name FieldActionQueue
extends RefCounted

signal got_actions_to_do
signal flushed

var _field: Field
var _queue: Array = []
var _action_conditions_map := CallableMap.new()


func _init(p_field: Field) -> void:
	_field = p_field


func connect_condition(action_name: String, condition: Callable) -> void:
	_action_conditions_map.add(action_name, condition)


func disconnect_condition(action_name: String, condition: Callable) -> void:
	_action_conditions_map.remove(action_name, condition)


func connect_post_action(action_name: String, callable: Callable) -> void:
	var signal_name := "post_" + action_name
	if not has_user_signal(signal_name):
		add_user_signal(signal_name)
	connect(signal_name, callable)


func disconnect_post_action(action_name: String, callable: Callable) -> void:
	var signal_name := "post_" + action_name
	assert(has_user_signal(signal_name))
	disconnect(signal_name, callable)


func push(action: Callable) -> void:
	var condition_results := _action_conditions_map.call_by_key(
			action.get_method(), action.get_bound_arguments())
	if condition_results.all(func(a: bool): return a):
		_add_action(action)


func _add_action(action: Callable) -> void:
	_queue.append(action)
	if _queue.size() == 1:
		got_actions_to_do.emit()


func flush() -> void:
	if _queue.size() > 0:
		for action in _queue:
			if not action.is_null():
				action.call()
				_emit_post_action_signal(action)
		_queue.clear()
		flushed.emit()


func _emit_post_action_signal(action: Callable) -> void:
	var signal_name := "post_" + action.get_method()
	if has_user_signal(signal_name):
		Utils.emit_signal_v(Signal(self, signal_name),
				action.get_bound_arguments())
