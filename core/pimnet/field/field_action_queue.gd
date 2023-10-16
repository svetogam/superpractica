##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name FieldActionQueue
extends Reference

signal got_actions_to_do
signal flushed

var _field: Subscreen
var _queue := []
var _action_condition_callbacker := KeyCallbacker.new()


func _init(p_field: Subscreen) -> void:
	_field = p_field


func connect_condition(action_name: String, object: Object, method: String) -> void:
	_action_condition_callbacker.add(action_name, object, method)


func disconnect_condition(action_name: String, object: Object, method: String) -> void:
	_action_condition_callbacker.remove(action_name, object, method)


func connect_post_action(action_name: String, object: Object, method: String) -> void:
	var signal_name = "post_" + action_name
	if not has_user_signal(signal_name):
		add_user_signal(signal_name)
	connect(signal_name, object, method)


func disconnect_post_action(action_name: String, object: Object, method: String) -> void:
	var signal_name = "post_" + action_name
	assert(has_user_signal(signal_name))
	disconnect(signal_name, object, method)


func push(method_name: String, args:=[]) -> void:
	var action = FieldAction.new(_field.actions, method_name, args)
	if _action_condition_callbacker.do_callbacks_return_true(method_name, args):
		_add_action(action)


func push_empty() -> void:
	var action = EmptyAction.new()
	_add_action(action)


func push_action_or_empty(action_name: String, args:=[]) -> void:
	if action_name == "empty":
		push_empty()
	else:
		push(action_name, args)


func _add_action(action: FieldAction) -> void:
	_queue.append(action)
	if _queue.size() == 1:
		emit_signal("got_actions_to_do")


func flush() -> void:
	if _queue.size() > 0:
		for action in _queue:
			action.execute()
			if not action is EmptyAction:
				_emit_post_action_signal(action)
		_queue.clear()
		emit_signal("flushed")


func _emit_post_action_signal(action) -> void:
	var signal_name = "post_" + action.method_name
	if has_user_signal(signal_name):
		Utils.emit_signal_v(self, signal_name, action.args)


class FieldAction:
	var _field_actor: Object
	var method_name: String
	var args: Array

	func _init(p_field_actor: Object, p_method_name: String, p_args: Array) -> void:
		_field_actor = p_field_actor
		method_name = p_method_name
		args = p_args

	func execute() -> void:
		_field_actor.callv(method_name, args)


class EmptyAction:
	extends FieldAction

	func _init().(null, "", []) -> void:
		pass

	func execute() -> void:
		pass
