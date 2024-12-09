#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GridCountingProcessCountPieces
extends FieldProcess

const COUNT_DELAY := 0.5
var pieces: Array
var zero_cell_number: int
var _current_count: int = 0
var _last_count_object: NumberEffect


func _init(p_pieces: Array, p_zero_cell_number: int) -> void:
	pieces = p_pieces
	zero_cell_number = p_zero_cell_number


func _ready() -> void:
	_count_next()


func _count_next() -> void:
	if not pieces.is_empty():
		var next_object = pieces[_current_count]
		_last_count_object = field.count_piece(next_object)
		_current_count += 1
	else:
		var zero_position = field.dynamic_model.get_grid_cell(zero_cell_number).position
		_last_count_object = field.math_effects.give_number(0, zero_position)

	Game.call_after(_on_delay_completed, COUNT_DELAY)


func _on_delay_completed() -> void:
	if _current_count == pieces.size():
		complete(_last_count_object)
	else:
		_count_next()
