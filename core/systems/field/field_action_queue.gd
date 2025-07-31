# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name FieldActionQueue
extends RefCounted

signal got_actions_to_do
signal flushed

var auto_flush := true
var _field: Field
var _queue: Array = []


func _init(p_field: Field) -> void:
	_field = p_field


func push(action: FieldAction) -> void:
	assert(action != null)

	# Ignore invalid actions
	if not action.is_valid():
		return

	# Add action only if no action conditions return false
	var results: Array = []
	var result: bool
	if _field._action_conditions.has(action.name):
		for condition in _field._action_conditions[action.name]:
			result = condition.call(action)
			results.append(result)
	if results.all(func(a: bool): return a):
		_queue.append(action)
		if _queue.size() == 1:
			got_actions_to_do.emit()

	if auto_flush:
		flush()


func flush() -> void:
	if _queue.size() > 0:
		for action in _queue:
			if action.is_possible():
				action.do()
				_field.action_done.emit(action)
		_queue.clear()
		flushed.emit()
