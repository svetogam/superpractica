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

const FIRST := "Select the number {start_number} on the board."
const SECOND := "Circle as many numbers below {start_number} as in the tens digit of {addend}. "\
		+ "That is, {addend_tens} numbers."
const THIRD := "Circle as many numbers right of {partial_completion} as in the ones digit "\
		+ "of {addend}. That is, {addend_ones} numbers."
const FOURTH :=\
		"This shows {start_number} + {addend}. Click the \"Complete\" button to say you're done."


const DATA := {
	"select_number": {
		"name": "Select",
		"grid_position": Vector2(0, 0),
		"instructions": FIRST,
		"previous": [],
		"flags": ["initial"],
	},
	"circle_down": {
		"name": "Add Tens",
		"grid_position": Vector2(0, 1),
		"instructions": SECOND,
		"previous": ["select_number"],
		"flags": [],
	},
	"circle_right": {
		"name": "Add Ones",
		"grid_position": Vector2(0, 2),
		"instructions": THIRD,
		"previous": ["circle_down"],
		"flags": [],
	},
	"press_button": {
		"name": "Complete",
		"grid_position": Vector2(0, 3),
		"instructions": FOURTH,
		"previous": ["circle_right"],
		"flags": ["final"],
	},
}
