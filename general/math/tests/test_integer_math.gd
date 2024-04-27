#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

extends GdUnitTestSuite


func test_get_digit_at_place() -> void:
	assert_int(IntegerMath.get_digit_at_place(0, 1)).is_equal(0)
	assert_int(IntegerMath.get_digit_at_place(5, 1)).is_equal(5)

	assert_int(IntegerMath.get_digit_at_place(10, 1)).is_equal(0)
	assert_int(IntegerMath.get_digit_at_place(10, 2)).is_equal(1)
	assert_int(IntegerMath.get_digit_at_place(10, 3)).is_equal(0)

	assert_int(IntegerMath.get_digit_at_place(236, 1)).is_equal(6)
	assert_int(IntegerMath.get_digit_at_place(236, 2)).is_equal(3)
	assert_int(IntegerMath.get_digit_at_place(236, 3)).is_equal(2)
	assert_int(IntegerMath.get_digit_at_place(236, 4)).is_equal(0)


func test_get_number_of_digits():
	assert_int(IntegerMath.get_number_of_digits(0)).is_equal(1)
	assert_int(IntegerMath.get_number_of_digits(5)).is_equal(1)
	assert_int(IntegerMath.get_number_of_digits(10)).is_equal(2)
	assert_int(IntegerMath.get_number_of_digits(236)).is_equal(3)
	assert_int(IntegerMath.get_number_of_digits(9999999)).is_equal(7)


func test_get_number_as_digit_list():
	assert_array(IntegerMath.get_number_as_digit_list(0)).is_equal([0])
	assert_array(IntegerMath.get_number_as_digit_list(5)).is_equal([5])
	assert_array(IntegerMath.get_number_as_digit_list(10)).is_equal([0, 1])
	assert_array(IntegerMath.get_number_as_digit_list(236)).is_equal([6, 3, 2])
