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

var auto_flush := true
var _field: Field
var _queue: Array = []
var _action_conditions := {} # {action_name: [Callable, ...], ...}


func _init(p_field: Field) -> void:
	_field = p_field


func add_action_condition(action_name: String, condition_func: Callable) -> void:
	if not _action_conditions.has(action_name):
		_action_conditions[action_name] = []
	_action_conditions[action_name].append(condition_func)


func remove_action_condition(action_name: String, condition_func: Callable) -> void:
	if not _action_conditions.has(action_name):
		return
	_action_conditions[action_name].erase(condition_func)
	if _action_conditions[action_name].is_empty():
		_action_conditions.erase(action_name)


func connect_post_action(action_name: String, callable: Callable) -> void:
	return
	#var signal_name := "post_" + action_name
	#if not has_user_signal(signal_name):
		#add_user_signal(signal_name)
	#connect(signal_name, callable)


func disconnect_post_action(action_name: String, callable: Callable) -> void:
	return
	#var signal_name := "post_" + action_name
	#assert(has_user_signal(signal_name))
	#disconnect(signal_name, callable)


func push(action: FieldAction) -> void:
	assert(action != null)
	assert(action.is_valid())

	# Add action only if action has no conditions or they all return true
	var condition_results: Array = []
	for condition in _action_conditions.get(action.name, []):
		condition_results.append(condition.call(action))
	if condition_results.all(func(a: bool): return a):
		_add_action(action)

	if auto_flush:
		flush()


func _add_action(action: FieldAction) -> void:
	_queue.append(action)
	if _queue.size() == 1:
		got_actions_to_do.emit()


func flush() -> void:
	if _queue.size() > 0:
		for action in _queue:
			#if not action.is_null():
				#action.call()
				#_emit_post_action_signal(action)
			action.do()
		_queue.clear()
		flushed.emit()


#func _emit_post_action_signal(action: Callable) -> void:
	#var signal_name := "post_" + action.get_method()
	#if has_user_signal(signal_name):
		#Signal(self, signal_name).emit.callv(action.get_bound_arguments())
