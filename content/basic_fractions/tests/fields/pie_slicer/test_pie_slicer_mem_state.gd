##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends GutTest

const VECTOR_1 := Vector2(1, 1)
const VECTOR_2 := Vector2(1, 2)
const VECTOR_3 := Vector2(2, 1)
const VECTOR_4 := Vector2(1, 1.1)


func test_empty_are_equal():
	var mem_state_1 = PieSlicerMemState.new([])
	var mem_state_2 = PieSlicerMemState.new([])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), true)


func test_recognize_different_vectors():
	var mem_state_1 = PieSlicerMemState.new([VECTOR_1])
	var mem_state_2 = PieSlicerMemState.new([VECTOR_2])
	var mem_state_3 = PieSlicerMemState.new([VECTOR_3])
	var mem_state_4 = PieSlicerMemState.new([VECTOR_4])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), false)
	assert_eq(mem_state_1.is_equal_to(mem_state_3), false)
	assert_eq(mem_state_1.is_equal_to(mem_state_4), false)
	assert_eq(mem_state_2.is_equal_to(mem_state_3), false)
	assert_eq(mem_state_2.is_equal_to(mem_state_4), false)
	assert_eq(mem_state_3.is_equal_to(mem_state_4), false)


func test_recognize_different_counts():
	var mem_state_1 = PieSlicerMemState.new([])
	var mem_state_2 = PieSlicerMemState.new([VECTOR_1])
	var mem_state_3 = PieSlicerMemState.new([VECTOR_1, VECTOR_1])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), false)
	assert_eq(mem_state_1.is_equal_to(mem_state_3), false)
	assert_eq(mem_state_2.is_equal_to(mem_state_3), false)


func test_ignore_different_order():
	var mem_state_1 = PieSlicerMemState.new([VECTOR_1, VECTOR_2, VECTOR_3])
	var mem_state_2 = PieSlicerMemState.new([VECTOR_1, VECTOR_3, VECTOR_2])
	var mem_state_3 = PieSlicerMemState.new([VECTOR_2, VECTOR_1, VECTOR_3])
	var mem_state_4 = PieSlicerMemState.new([VECTOR_3, VECTOR_2, VECTOR_1])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), true)
	assert_eq(mem_state_1.is_equal_to(mem_state_3), true)
	assert_eq(mem_state_1.is_equal_to(mem_state_4), true)
	assert_eq(mem_state_2.is_equal_to(mem_state_3), true)
	assert_eq(mem_state_2.is_equal_to(mem_state_4), true)
	assert_eq(mem_state_3.is_equal_to(mem_state_4), true)
