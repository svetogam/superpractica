#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldProgram

signal completed
signal completed_tens_only
signal affirmed
signal rejected

@export var _start_number: int
@export var _addend: int
var _current_number: int
var _target_number: int
var _completed_tens := false


func setup(p_start_number: int, p_addend: int) -> void:
	assert(not is_running())

	_start_number = p_start_number
	_addend = p_addend


func _start() -> void:
	field.connect_condition("toggle_circle", _decide_toggle_circle)
	field.connect_post_action("toggle_circle", _on_circle_toggled)

	_current_number = _start_number
	_target_number = _start_number + _addend


func _decide_toggle_circle(square: NumberSquare) -> bool:
	if square.number == _find_next_number():
		_current_number = square.number
		effects.affirm(square.position)
		affirmed.emit()

		return true

	else:
		effects.reject(square.position)
		rejected.emit()
		return false


func _on_circle_toggled(square: NumberSquare) -> void:
	assert(square.circled)
	square.set_circle_variant("affirmation")

	if _current_number == _target_number:
		completed.emit()
		stop()
	elif not _completed_tens and _target_number < _current_number + 10:
		_completed_tens = true
		completed_tens_only.emit()


func _find_next_number() -> int:
	if _counting_by() == "tens":
		return _current_number + 10
	else:
		return _current_number + 1


func _counting_by() -> String:
	if _target_number >= _current_number + 10:
		return "tens"
	else:
		return "ones"


func _end() -> void:
	field.disconnect_condition("toggle_circle", _decide_toggle_circle)
	field.disconnect_post_action("toggle_circle", _on_circle_toggled)
