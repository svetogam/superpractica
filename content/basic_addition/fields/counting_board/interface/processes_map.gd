##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends StaticDictionary

static func get_data() -> Dictionary:
	return {
		"count_counters": preload("processes/count_counters.gd"),
		"count_circles_in_direction": preload("processes/count_circles_in_direction.gd"),
		"count_squares": preload("processes/count_squares.gd"),
		"empty_count_square": preload("processes/empty_count_square.gd"),
		"circle_numbers_in_direction": preload("processes/circle_numbers_in_direction.gd"),
		"add_by_circles": preload("processes/add_by_circles.gd"),
	}
