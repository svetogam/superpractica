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

const MakePieFromFraction1 = "Cut the pie into {denominator} slices."
const MakePieFromFraction2 = "Select {numerator} regions."


const DATA = {
	"cut_slices": {
		"name": "Cut Slices",
		"grid_position": Vector2(0, 0),
		"instructions": MakePieFromFraction1,
		"previous": [],
		"flags": ["initial"],
	},
	"select_regions": {
		"name": "Select Regions",
		"grid_position": Vector2(1, 0),
		"instructions": MakePieFromFraction2,
		"previous": ["cut_slices"],
		"flags": ["final"],
	},
}
