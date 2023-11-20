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
		"Find the sum and enter it. Then press the \"Check\" button to verify that it's correct."


const DATA := {
	"select_sum": {
		"name": "Find Sum",
		"grid_position": Vector2(0, 0),
		"instructions": FIRST,
		"previous": [],
		"flags": ["initial", "final"],
	},
}
