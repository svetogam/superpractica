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
	field.action_queue.add_action_condition("toggle_mark", _decide_toggle_mark)


func _decide_toggle_mark(action: FieldAction) -> bool:
	var correct = action.grid_cell.number == _start_number
	if correct:
		action.grid_cell.set_ring_variant("affirmation")
		effects.affirm(action.grid_cell.position)
		stop()
		completed.emit()
	else:
		effects.reject(action.grid_cell.position)
		rejected.emit()
	return correct


func _end() -> void:
	field.action_queue.remove_action_condition("toggle_mark", _decide_toggle_mark)
