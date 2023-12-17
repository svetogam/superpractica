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
signal rejected

@export var _start_number: int


func setup(p_start_number: int) -> void:
	assert(not is_running())

	_start_number = p_start_number


func _start() -> void:
	field.connect_condition("toggle_highlight", _decide_toggle_highlight)


func _decide_toggle_highlight(square: NumberSquare) -> bool:
	var correct := square.number == _start_number
	if correct:
		effects.affirm(square.position)
		stop()
		completed.emit()
	else:
		effects.reject(square.position)
		rejected.emit()
	return correct


func _end() -> void:
	field.disconnect_condition("toggle_highlight", _decide_toggle_highlight)
