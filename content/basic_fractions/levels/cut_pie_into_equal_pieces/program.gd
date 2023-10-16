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

export(int) var slices: int
export(bool) var _random: bool
export(int) var _min_slices: int
export(int) var _max_slices: int

const BUTTON_ID := "button"
const BUTTON_TEXT := "Check"
var button: Button
var pim: Pim
var field: Field


func _setup_vars() -> void:
	slices = Utils.eval_given_or_random_int(slices, _random,
			_min_slices, _max_slices)


func _start() -> void:
	button = event_control.menu.add_button(BUTTON_ID, BUTTON_TEXT)
	pim = pimnet.get_pim("PieSlicerPim")
	field = pim.field

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	return {"slices": slices}
