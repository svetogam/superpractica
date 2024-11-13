#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends GdUnitTestSuite

const EMPTY := preload("empty.tres")
const CASE_1 := preload("case_1.tres")
const CASE_2 := preload("case_2.tres")
const CASE_3 := preload("case_3.tres")
const CASE_4 := preload("case_4.tres")
const CASE_5 := preload("case_5.tres")
const TestField := preload("res://content/packs/basic_addition/pims/grid_counting/field/"
		+ "grid_counting_field.tscn")
var field: GridCounting


func before():
	Game.debug.set_testing_preset(GameDebug.TestingPresets.SPEED)


func before_test():
	field = auto_free(TestField.instantiate())
	add_child(field)


func test_state_equality():
	assert_bool(EMPTY.equals(EMPTY)).is_true()
	assert_bool(EMPTY.equals(CASE_1)).is_false()

	assert_bool(CASE_1.equals(EMPTY)).is_false()
	assert_bool(CASE_1.equals(CASE_1)).is_true()
	assert_bool(CASE_1.equals(CASE_2)).is_false()

	assert_bool(CASE_2.equals(EMPTY)).is_false()
	assert_bool(CASE_2.equals(CASE_1)).is_false()
	assert_bool(CASE_2.equals(CASE_2)).is_true()

	assert_bool(CASE_3.equals(EMPTY)).is_false()
	assert_bool(CASE_3.equals(CASE_1)).is_false()
	assert_bool(CASE_3.equals(CASE_3)).is_true()

	assert_bool(CASE_4.equals(EMPTY)).is_false()
	assert_bool(CASE_4.equals(CASE_1)).is_false()
	assert_bool(CASE_4.equals(CASE_4)).is_true()

	assert_bool(CASE_5.equals(EMPTY)).is_false()
	assert_bool(CASE_5.equals(CASE_1)).is_false()
	assert_bool(CASE_5.equals(CASE_5)).is_true()


func test_state_building_and_loading():
	assert_bool(field.build_state().equals(EMPTY)).is_true()

	field.load_state(CASE_1)
	assert_bool(field.build_state().equals(CASE_1)).is_true()

	field.load_state(CASE_2)
	assert_bool(field.build_state().equals(CASE_2)).is_true()

	field.load_state(CASE_3)
	assert_bool(field.build_state().equals(CASE_3)).is_true()

	field.load_state(CASE_4)
	assert_bool(field.build_state().equals(CASE_4)).is_true()


func test_find_grid_cells():
	#get_grid_cell_list
	assert_array(field.get_grid_cell_list()).has_size(100)
	assert_array([
		field.get_grid_cell_list()[0],
		field.get_grid_cell_list()[54],
		field.get_grid_cell_list()[99],
	]).extract("get", ["number"]).contains_exactly([1, 55, 100])

	#get_grid_cell
	assert_array([
		field.get_grid_cell(1),
		field.get_grid_cell(55),
		field.get_grid_cell(100),
	]).extract("get", ["number"]).contains_exactly([1, 55, 100])

	#get_grid_cell_at_point
	assert_array([
		field.get_grid_cell_at_point(Vector2(20, 20)),
		field.get_grid_cell_at_point(Vector2(100, 100)),
		field.get_grid_cell_at_point(Vector2(200, 200)),
	]).extract("get", ["number"]).contains_exactly([1, 23, 56])
	assert_object(field.get_grid_cell_at_point(Vector2(500, 500))).is_null()

	#get_grid_cells_by_numbers
	assert_array(field.get_grid_cells_by_numbers([])).is_empty()
	assert_array(field.get_grid_cells_by_numbers([1, 2, 4, 6, 25, 67])).extract(
			"get", ["number"]).contains_exactly([1, 2, 4, 6, 25, 67])

	#get_grid_cells_by_row
	assert_array(field.get_grid_cells_by_row(1)).extract(
			"get", ["number"]).contains_exactly([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
	assert_array(field.get_grid_cells_by_row(10)).extract(
			"get", ["number"]).contains_exactly([91, 92, 93, 94, 95, 96, 97, 98, 99, 100])

	#get_marked_cell
	field.load_state(EMPTY)
	assert_object(field.get_marked_cell()).is_null()

	field.load_state(CASE_1)
	assert_object(field.get_marked_cell()).is_null()

	field.load_state(CASE_2)
	assert_int(field.get_marked_cell().number).is_equal(35)

	field.load_state(CASE_4)
	assert_int(field.get_marked_cell().number).is_equal(20)

	#get_grid_cells_with_units
	field.load_state(EMPTY)
	assert_array(field.get_grid_cells_with_units()).is_empty()

	field.load_state(CASE_1)
	assert_array(field.get_grid_cells_with_units()).extract(
			"get", ["number"]).contains_exactly([1, 2, 3, 98, 99, 100])

	field.load_state(CASE_2)
	assert_array(field.get_grid_cells_with_units()).extract(
			"get", ["number"]).contains_exactly([15, 25, 33, 34, 36, 37, 45, 55])

	field.load_state(CASE_4)
	assert_array(field.get_grid_cells_with_units()).extract(
			"get", ["number"]).contains_exactly([60, 71])


func test_find_units():
	#get_unit_list
	field.load_state(EMPTY)
	assert_array(field.get_unit_list()).is_empty()

	field.load_state(CASE_1)
	assert_array(field.get_unit_list()).has_size(6)

	field.load_state(CASE_2)
	assert_array(field.get_unit_list()).has_size(8)

	field.load_state(CASE_4)
	assert_array(field.get_unit_list()).has_size(2)

	#get_unit
	field.load_state(CASE_1)
	assert_int(field.get_unit(1).cell.number).is_equal(1)
	assert_int(field.get_unit(2).cell.number).is_equal(2)
	assert_int(field.get_unit(3).cell.number).is_equal(3)
	assert_object(field.get_unit(4)).is_null()
	assert_object(field.get_unit(97)).is_null()
	assert_int(field.get_unit(98).cell.number).is_equal(98)
	assert_int(field.get_unit(99).cell.number).is_equal(99)
	assert_int(field.get_unit(100).cell.number).is_equal(100)

	field.load_state(CASE_2)
	assert_object(field.get_unit(35)).is_null()

	field.load_state(CASE_3)
	assert_object(field.get_unit(1)).is_null()


func test_find_ten_blocks():
	#get_ten_block_list
	field.load_state(EMPTY)
	assert_array(field.get_ten_block_list()).is_empty()

	field.load_state(CASE_1)
	assert_array(field.get_ten_block_list()).is_empty()

	field.load_state(CASE_3)
	assert_array(field.get_ten_block_list()).extract(
			"get", ["row_number"]).contains_exactly([9, 10])

	field.load_state(CASE_4)
	assert_array(field.get_ten_block_list()).extract(
			"get", ["row_number"]).contains_exactly([1, 3, 4, 7])

	#get_ten_block
	field.load_state(CASE_3)
	assert_int(field.get_ten_block(9).row_number).is_equal(9)
	assert_int(field.get_ten_block(10).row_number).is_equal(10)
	assert_object(field.get_ten_block(6)).is_null()

	field.load_state(CASE_4)
	assert_int(field.get_ten_block(1).row_number).is_equal(1)
	assert_int(field.get_ten_block(3).row_number).is_equal(3)
	assert_int(field.get_ten_block(4).row_number).is_equal(4)
	assert_int(field.get_ten_block(7).row_number).is_equal(7)
	assert_object(field.get_ten_block(6)).is_null()


func test_query_static_numbers():
	#get_numbers
	assert_array(field.get_numbers()).has_size(100)
	assert_array([
		field.get_numbers()[0],
		field.get_numbers()[54],
		field.get_numbers()[99],
	]).contains_exactly([1, 55, 100])

	#get_first_number_in_row
	assert_int(field.get_first_number_in_row(1)).is_equal(1)
	assert_int(field.get_first_number_in_row(2)).is_equal(11)
	assert_int(field.get_first_number_in_row(5)).is_equal(41)
	assert_int(field.get_first_number_in_row(10)).is_equal(91)

	#get_last_number_in_row
	assert_int(field.get_last_number_in_row(1)).is_equal(10)
	assert_int(field.get_last_number_in_row(2)).is_equal(20)
	assert_int(field.get_last_number_in_row(5)).is_equal(50)
	assert_int(field.get_last_number_in_row(10)).is_equal(100)

	#get_row_number_for_cell_number
	assert_int(field.get_row_number_for_cell_number(3)).is_equal(1)
	assert_int(field.get_row_number_for_cell_number(15)).is_equal(2)
	assert_int(field.get_row_number_for_cell_number(46)).is_equal(5)
	assert_int(field.get_row_number_for_cell_number(100)).is_equal(10)

	#get_numbers_between
	assert_array(field.get_numbers_between(7, 12, false)).contains_exactly([8, 9, 10, 11])
	assert_array(field.get_numbers_between(7, 12, true)).is_empty()
	assert_array(field.get_numbers_between(7, 47, true)).contains_exactly([17, 27, 37])

	#get_numbers_by_skip_count
	assert_array(field.get_numbers_by_skip_count(0, 1, 5)).contains_exactly(
			[1, 2, 3, 4, 5])
	assert_array(field.get_numbers_by_skip_count(3, 2, 20)).contains_exactly(
			[5, 7, 9, 11, 13, 15, 17, 19])
	assert_array(field.get_numbers_by_skip_count(5, 5, 8)).contains_exactly([])

	#get_numbers_in_direction
	assert_array(field.get_numbers_in_direction(5, 4, "right")).contains_exactly(
			[6, 7, 8, 9])
	assert_array(field.get_numbers_in_direction(8, 5, "right")).contains_exactly(
			[9, 10, 11, 12, 13]) # Maybe this should be [9, 10] instead.
	assert_array(field.get_numbers_in_direction(35, 3, "down")).contains_exactly(
			[45, 55, 65])
	assert_array(field.get_numbers_in_direction(88, 10, "down")).contains_exactly(
			[98])


func test_query_marked_cells():
	#get_numbers_with_units
	field.load_state(CASE_1)
	assert_array(field.get_numbers_with_units()).contains_exactly([1, 2, 3, 98, 99, 100])

	field.load_state(CASE_4)
	assert_array(field.get_numbers_with_units()).contains_exactly([60, 71])

	field.load_state(CASE_3)
	assert_array(field.get_numbers_with_units()).is_empty()

	#is_cell_occupied
	field.load_state(CASE_1)
	assert_bool(field.is_cell_occupied(field.get_grid_cell(1))).is_true()
	assert_bool(field.is_cell_occupied(field.get_grid_cell(2))).is_true()
	assert_bool(field.is_cell_occupied(field.get_grid_cell(3))).is_true()
	assert_bool(field.is_cell_occupied(field.get_grid_cell(4))).is_false()

	field.load_state(CASE_4)
	assert_bool(field.is_cell_occupied(field.get_grid_cell(1))).is_true()
	assert_bool(field.is_cell_occupied(field.get_grid_cell(2))).is_true()
	assert_bool(field.is_cell_occupied(field.get_grid_cell(20))).is_false()

	#does_number_have_unit
	field.load_state(CASE_1)
	assert_bool(field.does_number_have_unit(1)).is_true()
	assert_bool(field.does_number_have_unit(2)).is_true()
	assert_bool(field.does_number_have_unit(3)).is_true()
	assert_bool(field.does_number_have_unit(4)).is_false()
	assert_bool(field.does_number_have_unit(98)).is_true()

	field.load_state(CASE_4)
	assert_bool(field.does_number_have_unit(1)).is_false()
	assert_bool(field.does_number_have_unit(20)).is_false()

	#get_contiguous_numbers_with_units_from
	field.load_state(CASE_1)
	assert_array(field.get_contiguous_numbers_with_units_from(1)).contains_exactly(
			[1, 2, 3])
	assert_array(field.get_contiguous_numbers_with_units_from(2)).contains_exactly([2, 3])
	assert_array(field.get_contiguous_numbers_with_units_from(3)).contains_exactly([3])
	assert_array(field.get_contiguous_numbers_with_units_from(55)).is_empty()
	assert_array(field.get_contiguous_numbers_with_units_from(98)).contains_exactly(
			[98, 99, 100])

	field.load_state(CASE_2)
	assert_array(field.get_contiguous_numbers_with_units_from(33)).contains_exactly(
			[33, 34])
	assert_array(field.get_contiguous_numbers_with_units_from(35)).is_empty()

	field.load_state(CASE_4)
	assert_array(field.get_contiguous_numbers_with_units_from(1)).is_empty()
	assert_array(field.get_contiguous_numbers_with_units_from(60)).contains_exactly([60])

	#get_contiguous_occupied_numbers_from
	field.load_state(CASE_1)
	assert_array(field.get_contiguous_occupied_numbers_from(1)).contains_exactly(
			[1, 2, 3])
	assert_array(field.get_contiguous_occupied_numbers_from(2)).contains_exactly([2, 3])
	assert_array(field.get_contiguous_occupied_numbers_from(3)).contains_exactly([3])
	assert_array(field.get_contiguous_occupied_numbers_from(55)).is_empty()
	assert_array(field.get_contiguous_occupied_numbers_from(98)).contains_exactly(
			[98, 99, 100])

	field.load_state(CASE_2)
	assert_array(field.get_contiguous_occupied_numbers_from(33)).contains_exactly(
			[33, 34])
	assert_array(field.get_contiguous_occupied_numbers_from(35)).is_empty()

	field.load_state(CASE_4)
	assert_array(field.get_contiguous_occupied_numbers_from(1)).contains_exactly(
			[1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
	assert_array(field.get_contiguous_occupied_numbers_from(60)).contains_exactly(
			[60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71])

	#get_marked_numbers
	field.load_state(CASE_1)
	assert_array(field.get_marked_numbers()).is_empty()

	field.load_state(CASE_2)
	assert_array(field.get_marked_numbers()).contains_exactly([35])

	field.load_state(CASE_3)
	assert_array(field.get_marked_numbers()).is_empty()

	field.load_state(CASE_4)
	assert_array(field.get_marked_numbers()).contains_exactly([20])

	#is_cell_marked
	field.load_state(CASE_4)
	assert_bool(field.is_cell_marked(field.get_grid_cell(1))).is_false()
	assert_bool(field.is_cell_marked(field.get_grid_cell(20))).is_true()
	assert_bool(field.is_cell_marked(field.get_grid_cell(60))).is_false()


func test_query_marked_rows():
	#is_row_occupied
	field.load_state(CASE_1)
	assert_bool(field.is_row_occupied(1)).is_true()

	field.load_state(CASE_3)
	assert_bool(field.is_row_occupied(8)).is_false()
	assert_bool(field.is_row_occupied(9)).is_true()
	assert_bool(field.is_row_occupied(10)).is_true()

	field.load_state(CASE_4)
	assert_bool(field.is_row_occupied(2)).is_false()

	field.load_state(CASE_5)
	assert_bool(field.is_row_occupied(2)).is_true()
	assert_bool(field.is_row_occupied(3)).is_true()

	#does_row_have_ten_block
	field.load_state(CASE_1)
	assert_bool(field.does_row_have_ten_block(1)).is_false()

	field.load_state(CASE_3)
	assert_bool(field.does_row_have_ten_block(8)).is_false()
	assert_bool(field.does_row_have_ten_block(9)).is_true()
	assert_bool(field.does_row_have_ten_block(10)).is_true()

	field.load_state(CASE_4)
	assert_bool(field.does_row_have_ten_block(2)).is_false()

	field.load_state(CASE_5)
	assert_bool(field.does_row_have_ten_block(2)).is_false()
	assert_bool(field.does_row_have_ten_block(3)).is_false()

	#get_contiguous_rows_with_ten_blocks_from
	field.load_state(CASE_1)
	assert_array(field.get_contiguous_rows_with_ten_blocks_from(1)).is_empty()

	field.load_state(CASE_3)
	assert_array(field.get_contiguous_rows_with_ten_blocks_from(8)).is_empty()
	assert_array(field.get_contiguous_rows_with_ten_blocks_from(9)).contains_exactly(
			[9, 10])

	field.load_state(CASE_4)
	assert_array(field.get_contiguous_rows_with_ten_blocks_from(1)).contains_exactly([1])
	assert_array(field.get_contiguous_rows_with_ten_blocks_from(2)).is_empty()
	assert_array(field.get_contiguous_rows_with_ten_blocks_from(3)).contains_exactly(
			[3, 4])
	assert_array(field.get_contiguous_rows_with_ten_blocks_from(4)).contains_exactly([4])

	field.load_state(CASE_5)
	assert_array(field.get_contiguous_rows_with_ten_blocks_from(2)).is_empty()
	assert_array(field.get_contiguous_rows_with_ten_blocks_from(3)).is_empty()


func test_create_objects():
	#create_unit
	field.load_state(EMPTY)
	field.create_unit(field.get_grid_cell(1))
	field.create_unit(field.get_grid_cell(2))
	field.create_unit(field.get_grid_cell(3))
	field.create_unit(field.get_grid_cell(98))
	field.create_unit(field.get_grid_cell(99))
	field.create_unit(field.get_grid_cell(100))
	assert_bool(field.build_state().equals(CASE_1)).is_true()

	#create_unit_by_number
	field.load_state(EMPTY)
	field.create_unit_by_number(1)
	field.create_unit_by_number(2)
	field.create_unit_by_number(3)
	field.create_unit_by_number(98)
	field.create_unit_by_number(99)
	field.create_unit_by_number(100)
	assert_bool(field.build_state().equals(CASE_1)).is_true()

	#create_ten_block
	field.load_state(EMPTY)
	field.create_ten_block(9)
	field.create_ten_block(10)
	assert_bool(field.build_state().equals(CASE_3)).is_true()


func test_delete_objects():
	#delete_unit
	field.load_state(CASE_1)
	field.delete_unit(field.get_unit(1))
	field.delete_unit(field.get_unit(2))
	field.delete_unit(field.get_unit(3))
	field.delete_unit(field.get_unit(98))
	field.delete_unit(field.get_unit(99))
	field.delete_unit(field.get_unit(100))
	assert_bool(field.build_state().equals(EMPTY)).is_true()

	#delete_unit_by_number
	field.load_state(CASE_1)
	field.delete_unit_by_number(1)
	field.delete_unit_by_number(2)
	field.delete_unit_by_number(3)
	field.delete_unit_by_number(98)
	field.delete_unit_by_number(99)
	field.delete_unit_by_number(100)
	assert_bool(field.build_state().equals(EMPTY)).is_true()

	#delete_block
	field.load_state(CASE_3)
	field.delete_block(field.get_ten_block(9))
	field.delete_block(field.get_ten_block(10))
	assert_bool(field.build_state().equals(EMPTY)).is_true()


func test_unit_actions():
	#move_unit
	field.load_state(CASE_1)
	field.move_unit(field.get_unit(1), field.get_grid_cell(4))
	field.move_unit(field.get_unit(2), field.get_grid_cell(5))
	field.move_unit(field.get_unit(3), field.get_grid_cell(10))
	field.move_unit(field.get_unit(98), field.get_grid_cell(55))
	field.move_unit(field.get_unit(99), field.get_grid_cell(55))
	field.move_unit(field.get_unit(100), field.get_grid_cell(100))
	assert_array(field.get_numbers_with_units()).contains_exactly([4, 5, 10, 55, 100])

	#move_unit_by_numbers
	field.load_state(CASE_1)
	field.move_unit_by_numbers(1, 4)
	field.move_unit_by_numbers(2, 5)
	field.move_unit_by_numbers(3, 10)
	field.move_unit_by_numbers(98, 55)
	field.move_unit_by_numbers(99, 55)
	field.move_unit_by_numbers(100, 100)
	assert_array(field.get_numbers_with_units()).contains_exactly([4, 5, 10, 55, 100])


func test_cell_actions():
	#toggle_mark
	field.load_state(EMPTY)
	field.toggle_mark(field.get_grid_cell(1))
	assert_array(field.get_marked_numbers()).contains_exactly([1])

	field.load_state(CASE_2)
	field.toggle_mark(field.get_grid_cell(100))
	assert_array(field.get_marked_numbers()).contains_exactly([100])

	field.load_state(CASE_2)
	field.toggle_mark(field.get_grid_cell(35))
	assert_array(field.get_marked_numbers()).is_empty()

	#mark_single_cell
	field.load_state(EMPTY)
	field.mark_single_cell(field.get_grid_cell(1))
	assert_array(field.get_marked_numbers()).contains_exactly([1])

	field.load_state(CASE_2)
	field.mark_single_cell(field.get_grid_cell(100))
	assert_array(field.get_marked_numbers()).contains_exactly([100])

	field.load_state(CASE_2)
	field.mark_single_cell(field.get_grid_cell(35))
	assert_array(field.get_marked_numbers()).contains_exactly([35])

	#unmark_cells
	field.load_state(EMPTY)
	field.unmark_cells()
	assert_array(field.get_marked_numbers()).is_empty()

	field.load_state(CASE_2)
	field.unmark_cells()
	assert_array(field.get_marked_numbers()).is_empty()


func test_make_effects():
	#math_effects
	field.load_state(EMPTY)
	assert_array([
		field.give_number_effect_by_grid_cell(field.get_grid_cell(1)).number,
		field.give_number_effect_by_grid_cell(field.get_grid_cell(3)).number,
		field.give_number_effect_by_grid_cell(field.get_grid_cell(5)).number,
		field.give_number_effect_by_grid_cell(field.get_grid_cell(7)).number,
		field.give_number_effect_by_grid_cell(field.get_grid_cell(19)).number,
	]).contains_exactly([1, 3, 5, 7, 19])
	assert_array([
		field.give_number_effect_by_number(1).number,
		field.give_number_effect_by_number(3).number,
		field.give_number_effect_by_number(5).number,
		field.give_number_effect_by_number(7).number,
		field.give_number_effect_by_number(19).number,
	]).contains_exactly([1, 3, 5, 7, 19])
	assert_int(field.math_effects.get_effects().size()).is_equal(10)

	#effect_counter
	field.load_state(CASE_1)
	assert_array([
		field.count_unit(field.get_unit(1)).number,
		field.count_unit(field.get_unit(2)).number,
		field.count_unit(field.get_unit(3)).number,
		field.count_unit(field.get_unit(98)).number,
	]).contains_exactly([1, 2, 3, 4])
	assert_array([
		field.count_cell(1).number,
		field.count_cell(3).number,
		field.count_cell(5).number,
		field.count_cell(7).number,
		field.count_cell(19).number,
	]).contains_exactly([5, 6, 7, 8, 9])
	assert_int(field.effect_counter.get_count()).is_equal(9)

	#warning_effects
	field.load_state(CASE_4)
	field.stage_unit_warning(field.get_unit(60))
	field.stage_unit_warning(field.get_unit(71))
	field.stage_ten_block_warning(field.get_ten_block(1))
	field.stage_ten_block_warning(field.get_ten_block(3))
	field.stage_ten_block_warning(field.get_ten_block(4))
	assert_bool(field.warning_effects.is_stage_empty()).is_false()
	assert_int(field.warning_effects.get_effects().size()).is_equal(0)

	field.warning_effects.flush_stage()
	assert_bool(field.warning_effects.is_stage_empty()).is_true()
	assert_int(field.warning_effects.get_effects().size()).is_equal(5)

	field.warning_effects.flush_stage()
	assert_bool(field.warning_effects.is_stage_empty()).is_true()
	assert_int(field.warning_effects.get_effects().size()).is_equal(0)


func test_field_setting():
	#set_empty
	field.load_state(CASE_1)
	field.set_empty()
	assert_bool(field.build_state().equals(EMPTY)).is_true()

	field.load_state(CASE_4)
	field.set_empty()
	assert_bool(field.build_state().equals(EMPTY)).is_true()
