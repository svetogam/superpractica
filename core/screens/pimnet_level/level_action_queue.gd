#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name LevelActionQueue
extends RefCounted

var _queue: Array = []
var _fields: Array = []


func setup(pimnet: Pimnet) -> void:
	for pim in pimnet.get_pim_list():
		if pim.has_field():
			_bind_to_field(pim.field)


func _bind_to_field(field: Field) -> void:
	_fields.append(field)
	field.action_queue.got_actions_to_do.connect(
			_on_actions_queued.bind(field.action_queue))
	field.action_queue.auto_flush = false


func _on_actions_queued(field_queue: FieldActionQueue) -> void:
	_queue.append(field_queue)


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
