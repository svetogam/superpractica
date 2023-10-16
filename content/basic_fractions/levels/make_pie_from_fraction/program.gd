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

export(int) var denominator := 1
export(int) var numerator := 1
export(bool) var _random := false
export(int) var _min_denominator := 1
export(int) var _max_denominator := 1
export(int) var _min_numerator := 0

const BUTTON_ID := "button"
const BUTTON_TEXT := "Check"
var button: Button
var pim: Pim
var field: Field
var fraction: SlotPanel


func _setup_vars() -> void:
	denominator = Utils.eval_given_or_random_int(denominator, _random,
			_min_denominator, _max_denominator)
	numerator = Utils.eval_given_or_random_int(numerator, _random,
			_min_numerator, denominator)


func _start() -> void:
	button = event_control.menu.add_button(BUTTON_ID, BUTTON_TEXT)
	pim = pimnet.get_pim("PieSlicerPim")
	field = pim.field
	fraction = pimnet.get_window_content("FractionWindow", "Fraction")

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	return {"denominator": denominator, "numerator": numerator}
