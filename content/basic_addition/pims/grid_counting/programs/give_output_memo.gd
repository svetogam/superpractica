#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PimProgram

signal output_decided(output_number) #int with -1 for no output


func _start() -> void:
	pim.output_slot.show()
	field.updated.connect(_on_field_updated)


func _on_field_updated() -> void:
	_update_output_memo()


func _update_output_memo() -> void:
	var output_number = _calc_output_number()
	if output_number == -1:
		pim.set_slot_empty()
	else:
		pim.set_slot(IntegerMemo, output_number)
	output_decided.emit(output_number)


func _calc_output_number() -> int:
	var highlights = field.get_highlighted_numbers()
	if highlights.size() > 1:
		return -1

	var first_number: int
	if highlights.size() == 0:
		first_number = 0
	else:
		first_number = highlights[0]
	var contiguous_numbers = field.get_contiguous_occupied_numbers_from(first_number + 1)
	if contiguous_numbers.is_empty():
		return first_number

	else:
		return contiguous_numbers.back()
