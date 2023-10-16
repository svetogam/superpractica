##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends LevelProgram

export(int) var start_number: int
export(int) var addend: int
export(bool) var _random_start_number: bool
export(int) var _min_start_number: int
export(int) var _max_start_number: int
export(bool) var _random_addend: bool
export(int) var _min_addend: int
export(int) var _max_addend: int

const BUTTON_ID := "button"
const BUTTON_TEXT := "Complete"
var pim: Pim
var field: Field


func _setup_vars() -> void:
	start_number = Utils.eval_given_or_random_int(start_number,
			_random_start_number, _min_start_number, _max_start_number)
	addend = Utils.eval_given_or_random_int(addend, _random_addend, _min_addend, _max_addend)


func _start() -> void:
	event_control.menu.add_button(BUTTON_ID, BUTTON_TEXT)
	event_control.menu.enabler.disable_all(true)
	pim = pimnet.get_pim("CountingBoardPim")
	field = pim.field

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	var addend_tens_digit = addend / 10
	var addend_ones_digit = addend % 10
	var partial_completion = start_number + addend_tens_digit * 10
	return {"start_number": start_number, "addend": addend,
			"addend_tens": addend_tens_digit, "addend_ones": addend_ones_digit,
			"partial_completion": partial_completion}
