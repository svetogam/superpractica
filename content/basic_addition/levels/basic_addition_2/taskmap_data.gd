#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends RefCounted

const FIRST := ("Select the number {start_number} on the board. "
		+ "Then click the \"Check\" button.")
const SECOND := ("Put a counter on the next {count} numbers "
		+ "after {start_number}. Then click the \"Check\" button.")
const THIRD := "Drag the sum into the slot to complete the equation."


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
	"drag_result": {
		"name": "Drag Result",
		"grid_position": Vector2(0, 2),
		"instructions": THIRD,
		"previous": ["put_counters"],
		"flags": ["final"],
	},
}
