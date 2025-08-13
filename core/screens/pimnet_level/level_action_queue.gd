# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LevelActionQueue
extends RefCounted

var _queue: Array = []
var _fields: Array = []


func add_field(field: Field) -> void:
	_fields.append(field)
	field.action_queue.got_actions_to_do.connect(
		_on_actions_queued.bind(field.action_queue)
	)
	field.action_queue.auto_flush = false


func reset() -> void:
	for field in _fields:
		field.action_queue.got_actions_to_do.disconnect(_on_actions_queued)
	_fields.clear()
	_queue.clear()


func flush() -> void:
	for field_queue in _queue:
		field_queue.flush()
	_queue.clear()


func is_empty() -> bool:
	return _queue.is_empty()


func _on_actions_queued(field_queue: FieldActionQueue) -> void:
	_queue.append(field_queue)
