##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name PieSlicerMemState
extends MemState

var slice_vector_list: Array


func _init(p_slice_vector_list: Array) -> void:
	slice_vector_list = p_slice_vector_list


func is_equal_to(other: MemState) -> bool:
	var check_func = funcref(Utils, "are_vectors_equal")
	return Utils.are_unsorted_lists_equal(slice_vector_list,
			other.slice_vector_list, check_func)
