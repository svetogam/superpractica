# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GridCountingProcessSumPieces
extends FieldProcess

const COUNT_DELAY := 0.5
var pieces: Array
var zero_cell_number: int
var _pieces_counted: int = 0
var _last_count_object: NumberSignal


func _init(p_pieces: Array, p_zero_cell_number: int) -> void:
	pieces = p_pieces
	zero_cell_number = p_zero_cell_number


func _ready() -> void:
	_count_next()


func _count_next() -> void:
	if not pieces.is_empty():
		var next_object = pieces[_pieces_counted]
		var value = field.get_object_value(next_object.object_type)
		_last_count_object = field.count_signaler.count_object(next_object, value)
		_pieces_counted += 1
	else:
		var zero_position = field.dynamic_model.get_grid_cell(zero_cell_number).position
		_last_count_object = field.info_signaler.popup_number(0, zero_position)

	Game.call_after(_on_delay_completed, COUNT_DELAY)


func _on_delay_completed() -> void:
	if _pieces_counted == pieces.size():
		complete(_last_count_object)
	else:
		_count_next()
