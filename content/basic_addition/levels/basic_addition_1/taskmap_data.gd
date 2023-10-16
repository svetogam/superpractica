##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Reference

const FIRST := "Select the number {start_number} on the board."
const SECOND := "Put a counter on the next {count} numbers after {start_number}."
const THIRD :=\
		"This shows {start_number} + {count}. Click the \"Complete\" button to say you're done."


const DATA := {
	"select_number": {
		"name": "Select",
		"grid_position": Vector2(0, 0),
		"instructions": FIRST,
		"previous": [],
		"flags": ["initial"],
	},
	"put_counters": {
		"name": "Count",
		"grid_position": Vector2(0, 1),
		"instructions": SECOND,
		"previous": ["select_number"],
		"flags": [],
	},
	"press_button": {
		"name": "Complete",
		"grid_position": Vector2(0, 2),
		"instructions": THIRD,
		"previous": ["put_counters"],
		"flags": ["final"],
	},
}
