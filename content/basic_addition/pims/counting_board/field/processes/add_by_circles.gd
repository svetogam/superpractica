#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldProcess

var _start_number: int
var _show_count: bool
var _addend_tens_digit: int
var _addend_ones_digit: int
var _second_start_number: int


func _init(p_start_number: int, p_addend: int, p_show_count := true) -> void:
	_start_number = p_start_number
	_show_count = p_show_count
	_addend_tens_digit = p_addend / 10
	_addend_ones_digit = p_addend % 10
	_second_start_number = _start_number + _addend_tens_digit * 10


func _ready() -> void:
	if _addend_tens_digit > 0:
		(CountingBoard.ProcessCircleNumbersInDirection
				.new(_start_number, _addend_tens_digit, "down", _show_count)
				.run(self, _on_tens_circled))
	elif _addend_ones_digit > 0:
		(CountingBoard.ProcessCircleNumbersInDirection
				.new(_second_start_number, _addend_ones_digit, "right", _show_count)
				.run(self, _on_ones_circled))
	else:
		complete()


func _on_tens_circled(_count: int) -> void:
	await Game.wait_for(0.5)

	if _addend_ones_digit > 0:
		(CountingBoard.ProcessCircleNumbersInDirection
				.new(_second_start_number, _addend_ones_digit, "right", _show_count)
				.run(self, _on_ones_circled))
	else:
		complete()


func _on_ones_circled(_count: int) -> void:
	complete()
