##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends RefCounted

const FIRST :=\
		"Select the number {start_number} on the board. Then click the \"Check\" button."
const SECOND := "Circle as many numbers below {start_number} as in the tens digit of {addend}. "\
		+ "That is, {addend_tens} numbers. "\
		+ "Then circle as many numbers to the right as in the ones digit of {addend}."\
		+ "That is, {addend_ones} numbers. Then click the \"Check\" button."
const THIRD := "Drag the sum into the slot to complete the equation. "\
		+ " Then click the \"Check\" button."


const DATA := {
	"select_number": {
		"name": "Select",
		"grid_position": Vector2(0, 0),
		"instructions": FIRST,
		"previous": [],
		"flags": ["initial"],
	},
	"add_by_circles": {
		"name": "Add by Circles",
		"grid_position": Vector2(0, 1),
		"instructions": SECOND,
		"previous": ["select_number"],
		"flags": [],
	},
	"drag_result": {
		"name": "Drag Result",
		"grid_position": Vector2(0, 2),
		"instructions": THIRD,
		"previous": ["add_by_circles"],
		"flags": ["final"],
	},
}
