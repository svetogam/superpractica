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
signal affirmed
signal rejected

@export var _start_number: int
@export var _count: int
var _next_number: int
var _last_number: int


func setup(p_start_number: int, p_count: int = -1) -> void:
	assert(not is_running())

	_start_number = p_start_number
	if p_count != -1:
		_count = p_count


func _start() -> void:
	#field.connect_condition("create_unit", _decide_create)
	#field.connect_post_action("create_unit", _on_unit_created)

	_next_number = _start_number + 1

	if _count != -1:
		_last_number = _start_number + _count
	else:
		_last_number = -1


func _decide_create(cell: GridCell) -> bool:
	if cell.number == _next_number:
		effects.affirm(cell.position)
		affirmed.emit()
		_next_number += 1

		return true

	else:
		effects.reject(cell.position)
		rejected.emit()
		return false


func _on_unit_created(cell: GridCell) -> void:
	assert(cell.get_unit() != null)

	cell.get_unit().set_variant("affirmation")

	if _is_completing_number(cell.number):
		completed.emit()
		stop()


func _is_completing_number(number: int) -> bool:
	return _last_number != -1 and number == _last_number


#func _end() -> void:
	#field.disconnect_condition("create_unit", _decide_create)
	#field.disconnect_post_action("create_unit", _on_unit_created)
