#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name CountInField
extends FieldProcess

const COUNT_DELAY := 0.5
var _to_count: Array
var _current_count: int = 0
var _last_count_object: NumberEffect


func _init(p_objects_to_count: Array) -> void:
	_to_count = p_objects_to_count


func _ready() -> void:
	_count_next()


func _count_next() -> void:
	if not _to_count.is_empty():
		var next_object = _to_count[_current_count]
		_last_count_object = _count(next_object)
		_current_count += 1
	else:
		_last_count_object = _count_zero()

	Game.call_after(_on_delay_completed, COUNT_DELAY)


# Virtual
func _count(_object: FieldObject) -> NumberEffect:
	assert(false)
	return null


# Virtual
func _count_zero() -> NumberEffect:
	assert(false)
	return null


func _on_delay_completed() -> void:
	if _current_count == _to_count.size():
		complete(_last_count_object)
	else:
		_count_next()
