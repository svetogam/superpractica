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


func _init(p_field: Field) -> void:
	_field = p_field


func push(action: FieldAction) -> void:
	assert(action != null)
	assert(action.is_valid())

	# Add action only if no active programs return false in _before_action()
	var results: Array = []
	var result: bool
	for program in _field.get_active_programs():
		result = program._before_action(action)
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
			action.do()
			for program in _field.get_active_programs():
				program._after_action(action)
		_queue.clear()
		flushed.emit()
