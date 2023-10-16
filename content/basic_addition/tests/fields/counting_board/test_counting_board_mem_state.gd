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

const SQUARE_1 := {"number": 1, "circled": false, "highlighted": false, "has_counter": false}
const SQUARE_2 := {"number": 2, "circled": false, "highlighted": false, "has_counter": false}
const SQUARE_3 := {"number": 1, "circled": true, "highlighted": false, "has_counter": false}
const SQUARE_4 := {"number": 1, "circled": false, "highlighted": true, "has_counter": false}
const SQUARE_5 := {"number": 1, "circled": false, "highlighted": false, "has_counter": true}


func test_empty_are_equal():
	var mem_state_1 = CountingBoardMemState.new([])
	var mem_state_2 = CountingBoardMemState.new([])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), true)


func test_recognize_different_squares():
	var mem_state_1 = CountingBoardMemState.new([SQUARE_1])
	var mem_state_2 = CountingBoardMemState.new([SQUARE_2])
	var mem_state_3 = CountingBoardMemState.new([SQUARE_3])
	var mem_state_4 = CountingBoardMemState.new([SQUARE_4])
	var mem_state_5 = CountingBoardMemState.new([SQUARE_5])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), false)
	assert_eq(mem_state_1.is_equal_to(mem_state_3), false)
	assert_eq(mem_state_1.is_equal_to(mem_state_4), false)
	assert_eq(mem_state_1.is_equal_to(mem_state_5), false)
	assert_eq(mem_state_2.is_equal_to(mem_state_3), false)
	assert_eq(mem_state_2.is_equal_to(mem_state_4), false)
	assert_eq(mem_state_2.is_equal_to(mem_state_5), false)
	assert_eq(mem_state_3.is_equal_to(mem_state_4), false)
	assert_eq(mem_state_3.is_equal_to(mem_state_5), false)
	assert_eq(mem_state_4.is_equal_to(mem_state_5), false)


func test_recognize_different_counts():
	var mem_state_1 = CountingBoardMemState.new([])
	var mem_state_2 = CountingBoardMemState.new([SQUARE_1])
	var mem_state_3 = CountingBoardMemState.new([SQUARE_1, SQUARE_1])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), false)
	assert_eq(mem_state_1.is_equal_to(mem_state_3), false)
	assert_eq(mem_state_2.is_equal_to(mem_state_3), false)


func test_ignore_different_order():
	var mem_state_1 = CountingBoardMemState.new([SQUARE_1, SQUARE_2, SQUARE_3])
	var mem_state_2 = CountingBoardMemState.new([SQUARE_1, SQUARE_3, SQUARE_2])
	var mem_state_3 = CountingBoardMemState.new([SQUARE_2, SQUARE_1, SQUARE_3])
	var mem_state_4 = CountingBoardMemState.new([SQUARE_3, SQUARE_2, SQUARE_1])
	assert_eq(mem_state_1.is_equal_to(mem_state_2), true)
	assert_eq(mem_state_1.is_equal_to(mem_state_3), true)
	assert_eq(mem_state_1.is_equal_to(mem_state_4), true)
	assert_eq(mem_state_2.is_equal_to(mem_state_3), true)
	assert_eq(mem_state_2.is_equal_to(mem_state_4), true)
	assert_eq(mem_state_3.is_equal_to(mem_state_4), true)
