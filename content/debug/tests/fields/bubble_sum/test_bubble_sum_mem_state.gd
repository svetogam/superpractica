#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends GutTest

const UNIT_1 := {"position": Vector2(12, 34)}
const UNIT_2 := {"position": Vector2(56, 78)}
const BUBBLE_1 := {"position": Vector2(12, 34), "radius": 5}
const BUBBLE_2 := {"position": Vector2(12, 34), "radius": 10}
const BUBBLE_3 := {"position": Vector2(67, 89), "radius": 5}


func test_empty_are_equal():
	var mem_state_1 := BubbleSumMemState.new([], [])
	var mem_state_2 := BubbleSumMemState.new([], [])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), true)


func test_recognize_different_units():
	var mem_state_1 := BubbleSumMemState.new([UNIT_1], [])
	var mem_state_2 := BubbleSumMemState.new([UNIT_2], [])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), false)


func test_recognize_different_bubbles():
	var mem_state_1 := BubbleSumMemState.new([], [BUBBLE_1])
	var mem_state_2 := BubbleSumMemState.new([], [BUBBLE_2])
	var mem_state_3 := BubbleSumMemState.new([], [BUBBLE_3])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), false)
	assert_eq(mem_state_1.is_equal_to(mem_state_3), false)
	assert_eq(mem_state_2.is_equal_to(mem_state_3), false)


func test_recognize_different_counts():
	var mem_state_1 := BubbleSumMemState.new([], [])
	var mem_state_2 := BubbleSumMemState.new([UNIT_1], [])
	var mem_state_3 := BubbleSumMemState.new([UNIT_1, UNIT_1], [])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), false)
	assert_eq(mem_state_1.is_equal_to(mem_state_3), false)
	assert_eq(mem_state_2.is_equal_to(mem_state_3), false)

	var mem_state_4 := BubbleSumMemState.new([], [BUBBLE_1])
	var mem_state_5 := BubbleSumMemState.new([], [BUBBLE_1, BUBBLE_1])
	assert_eq(mem_state_3.is_equal_to(mem_state_4), false)
	assert_eq(mem_state_3.is_equal_to(mem_state_5), false)
	assert_eq(mem_state_4.is_equal_to(mem_state_5), false)


func test_ignore_different_order():
	var mem_state_1 := BubbleSumMemState.new([UNIT_1, UNIT_2], [BUBBLE_1, BUBBLE_2])
	var mem_state_2 := BubbleSumMemState.new([UNIT_1, UNIT_2], [BUBBLE_2, BUBBLE_1])
	var mem_state_3 := BubbleSumMemState.new([UNIT_2, UNIT_1], [BUBBLE_1, BUBBLE_2])
	var mem_state_4 := BubbleSumMemState.new([UNIT_2, UNIT_1], [BUBBLE_2, BUBBLE_1])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), true)
	assert_eq(mem_state_1.is_equal_to(mem_state_3), true)
	assert_eq(mem_state_1.is_equal_to(mem_state_4), true)
	assert_eq(mem_state_2.is_equal_to(mem_state_3), true)
	assert_eq(mem_state_2.is_equal_to(mem_state_4), true)
	assert_eq(mem_state_3.is_equal_to(mem_state_4), true)
