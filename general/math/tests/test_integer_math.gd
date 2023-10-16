##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

extends GutTest


func test_get_digit_at_place():
	assert_eq(IntegerMath.get_digit_at_place(0, 1), 0)
	assert_eq(IntegerMath.get_digit_at_place(5, 1), 5)

	assert_eq(IntegerMath.get_digit_at_place(10, 1), 0)
	assert_eq(IntegerMath.get_digit_at_place(10, 2), 1)
	assert_eq(IntegerMath.get_digit_at_place(10, 3), 0)

	assert_eq(IntegerMath.get_digit_at_place(236, 1), 6)
	assert_eq(IntegerMath.get_digit_at_place(236, 2), 3)
	assert_eq(IntegerMath.get_digit_at_place(236, 3), 2)
	assert_eq(IntegerMath.get_digit_at_place(236, 4), 0)


func test_get_number_of_digits():
	assert_eq(IntegerMath.get_number_of_digits(0), 1)
	assert_eq(IntegerMath.get_number_of_digits(5), 1)
	assert_eq(IntegerMath.get_number_of_digits(10), 2)
	assert_eq(IntegerMath.get_number_of_digits(236), 3)


func test_get_number_as_digit_list():
	assert_eq(IntegerMath.get_number_as_digit_list(0), [0])
	assert_eq(IntegerMath.get_number_as_digit_list(5), [5])
	assert_eq(IntegerMath.get_number_as_digit_list(10), [0, 1])
	assert_eq(IntegerMath.get_number_as_digit_list(236), [6, 3, 2])
