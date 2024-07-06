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
extends CRMemento


func equals(other: CRMemento) -> bool:
	var units_check := Utils.are_unsorted_lists_equal(
			data.unit_data_list, other.data.unit_data_list)
	var bubbles_check := Utils.are_unsorted_lists_equal(
			data.bubble_data_list, other.data.bubble_data_list)
	return units_check and bubbles_check
