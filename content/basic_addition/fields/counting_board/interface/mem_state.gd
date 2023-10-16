##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name CountingBoardMemState
extends MemState

var number_squares_data_list: Array


func _init(p_number_squares_data_list) -> void:
	number_squares_data_list = p_number_squares_data_list


func is_equal_to(other: MemState) -> bool:
	var check_func = funcref(Utils, "are_dicts_equal")
	return Utils.are_unsorted_lists_equal(number_squares_data_list,
			other.number_squares_data_list, check_func)
