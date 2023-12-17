#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name BubbleSumMemState
extends MemState

var unit_data_list: Array
var bubble_data_list: Array


func _init(p_unit_data_list: Array, p_bubble_data_list: Array) -> void:
	unit_data_list = p_unit_data_list
	bubble_data_list = p_bubble_data_list


func is_equal_to(other: MemState) -> bool:
	var units_check := Utils.are_unsorted_lists_equal(unit_data_list,
			other.unit_data_list)
	var bubbles_check := Utils.are_unsorted_lists_equal(bubble_data_list,
			other.bubble_data_list)
	return units_check and bubbles_check
