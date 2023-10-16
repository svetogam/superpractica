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
		"sum_by_counters":
			preload("sum_by_counters/sum_by_counters.tscn"),
		"slot_panel_sum":
			preload("slot_panel_sum.gd"),
		"counting_board_start":
			preload("counting_board_start.gd"),
		"counting_board_count":
			preload("counting_board_count.gd"),
		"counting_board_sum":
			preload("counting_board_sum.gd"),
		"addition_by_circles":
			preload("addition_by_circles/addition_by_circles.tscn"),
		"sum_by_circles":
			preload("sum_by_circles/sum_by_circles.tscn"),
	}
