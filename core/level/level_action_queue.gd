##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name LevelActionQueue
extends Reference

var _queue := []
var _fields := []


func setup(pimnet: Pimnet) -> void:
	for pim in pimnet.get_pim_list():
		_bind_to_field(pim.field)


func _bind_to_field(field: Subscreen) -> void:
	_fields.append(field)
	field.action_queue.connect("got_actions_to_do", self, "_on_actions_queued",
			[field.action_queue])


func _on_actions_queued(field_queue: Object) -> void:
	_queue.append(field_queue)


func reset() -> void:
	for field in _fields:
		field.action_queue.disconnect("got_actions_to_do", self, "_on_actions_queued")
	_fields.clear()
	_queue.clear()


func flush() -> void:
	for field_queue in _queue:
		field_queue.flush()
	_queue.clear()


func is_empty() -> bool:
	return _queue.empty()
