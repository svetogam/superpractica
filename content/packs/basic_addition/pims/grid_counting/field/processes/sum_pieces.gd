#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingProcessSumPieces
extends FieldProcess

const COUNT_DELAY := 0.5
var _to_count: Array
var _pieces_counted: int = 0
var _current_count: int = 0
var _last_count_object: NumberEffect


func _ready() -> void:
	_to_count = field.dynamic_model.get_pieces()
	_count_next()


func _count_next() -> void:
	if not _to_count.is_empty():
		var next_object = _to_count[_pieces_counted]
		_current_count += field.get_object_value(next_object.object_type)
		_last_count_object = field.math_effects.give_number(
				_current_count, next_object.position)
		_pieces_counted += 1
	else:
		var zero_position = field.dynamic_model.get_grid_cell(1).position
		_last_count_object = field.math_effects.give_number(0, zero_position)

	Game.call_after(_on_delay_completed, COUNT_DELAY)


func _on_delay_completed() -> void:
	if _pieces_counted == _to_count.size():
		complete(_last_count_object)
	else:
		_count_next()
