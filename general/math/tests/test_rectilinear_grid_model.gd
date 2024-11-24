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

var model_10_10 := RectilinearGridModel.new(10, 10)
var model_1_1 := RectilinearGridModel.new(1, 1)
var model_8_16 := RectilinearGridModel.new(8, 16)


func test_cells():
	assert_int(model_10_10.cells).is_equal(100)
	assert_int(model_1_1.cells).is_equal(1)
	assert_int(model_8_16.cells).is_equal(128)


func test_get_first_cell_in_row():
	assert_int(model_10_10.get_first_cell_in_row(1)).is_equal(1)
	assert_int(model_10_10.get_first_cell_in_row(2)).is_equal(11)
	assert_int(model_10_10.get_first_cell_in_row(5)).is_equal(41)
	assert_int(model_10_10.get_first_cell_in_row(10)).is_equal(91)

	assert_int(model_1_1.get_first_cell_in_row(1)).is_equal(1)

	assert_int(model_8_16.get_first_cell_in_row(3)).is_equal(33)
	assert_int(model_8_16.get_first_cell_in_row(5)).is_equal(65)
	assert_int(model_8_16.get_first_cell_in_row(8)).is_equal(113)


func test_get_last_cell_in_row():
	assert_int(model_10_10.get_last_cell_in_row(1)).is_equal(10)
	assert_int(model_10_10.get_last_cell_in_row(2)).is_equal(20)
	assert_int(model_10_10.get_last_cell_in_row(5)).is_equal(50)
	assert_int(model_10_10.get_last_cell_in_row(10)).is_equal(100)

	assert_int(model_1_1.get_last_cell_in_row(1)).is_equal(1)

	assert_int(model_8_16.get_last_cell_in_row(3)).is_equal(48)
	assert_int(model_8_16.get_last_cell_in_row(5)).is_equal(80)
	assert_int(model_8_16.get_last_cell_in_row(8)).is_equal(128)


func test_get_cells_in_row():
	assert_array(model_10_10.get_cells_in_row(1)).contains_exactly(range(1, 11))
	assert_array(model_10_10.get_cells_in_row(2)).contains_exactly(range(11, 21))
	assert_array(model_10_10.get_cells_in_row(5)).contains_exactly(range(41, 51))
	assert_array(model_10_10.get_cells_in_row(10)).contains_exactly(range(91, 101))

	assert_array(model_1_1.get_cells_in_row(1)).contains_exactly([1])

	assert_array(model_8_16.get_cells_in_row(3)).contains_exactly(range(33, 49))
	assert_array(model_8_16.get_cells_in_row(5)).contains_exactly(range(65, 81))
	assert_array(model_8_16.get_cells_in_row(8)).contains_exactly(range(113, 129))


func test_get_cell():
	assert_int(model_10_10.get_cell(1, 1)).is_equal(1)
	assert_int(model_10_10.get_cell(2, 5)).is_equal(15)
	assert_int(model_10_10.get_cell(5, 2)).is_equal(42)
	assert_int(model_10_10.get_cell(10, 10)).is_equal(100)

	assert_int(model_1_1.get_cell(1, 1)).is_equal(1)

	assert_int(model_8_16.get_cell(3, 12)).is_equal(44)
	assert_int(model_8_16.get_cell(5, 5)).is_equal(69)
	assert_int(model_8_16.get_cell(8, 16)).is_equal(128)


func test_get_row_of_cell():
	assert_int(model_10_10.get_row_of_cell(3)).is_equal(1)
	assert_int(model_10_10.get_row_of_cell(15)).is_equal(2)
	assert_int(model_10_10.get_row_of_cell(46)).is_equal(5)
	assert_int(model_10_10.get_row_of_cell(100)).is_equal(10)

	assert_int(model_1_1.get_row_of_cell(1)).is_equal(1)

	assert_int(model_8_16.get_row_of_cell(40)).is_equal(3)
	assert_int(model_8_16.get_row_of_cell(65)).is_equal(5)
	assert_int(model_8_16.get_row_of_cell(128)).is_equal(8)
