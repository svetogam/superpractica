#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends LevelProgram

var start_number: int
var addend: int
var pim: Pim
var field: Field


func _setup_vars() -> void:
	start_number = Game.current_level.program_vars.new_start_number()
	addend = Game.current_level.program_vars.new_addend()


func _start() -> void:
	super()

	tool_panel.exclude_all("GridCounting")
	pim = pimnet.get_pim()
	field = pim.field

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	var addend_tens_digit: int = addend / 10
	var addend_ones_digit: int = addend % 10
	var partial_completion: int = start_number + addend_tens_digit * 10
	return {"start_number": start_number, "addend": addend,
			"addend_tens": addend_tens_digit, "addend_ones": addend_ones_digit,
			"partial_completion": partial_completion}
