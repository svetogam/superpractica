##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

#DO NOT MAINTAIN

extends SpLevelTest

var field: Field


func before_each():
	.before_each()
	_load_level("debug_windows", "counting_board")
	_load_ref_scene(
		"res://content/basic_addition/tests/pim_levels/do_not_maintain/counting_board_pim_ref.tscn"
	)
	field = pimnet.get_pim_field("CountingBoardPim")


#func test_circle_squares():
#	simulator.click_left_at($Ref/CircleNumber.position)
#	simulator.click_left_at($Ref/Square1.position)
#	simulator.click_left_at($Ref/Square2.position)
#	simulator.click_left_at($Ref/Square24.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_circled_numbers().size(), 3)
#
#	simulator.click_left_at($Ref/Square1.position)
#	simulator.click_left_at($Ref/Square24.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_circled_numbers().size(), 1)
#
#
#func test_mark_squares():
#	simulator.click_left_at($Ref/MarkSquare.position)
#	simulator.click_left_at($Ref/Square1.position)
#	simulator.click_left_at($Ref/Square2.position)
#	simulator.click_left_at($Ref/Square24.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_all_marked_numbers().size(), 1)
#	assert_eq(field.queries.get_highlighted_number_square().number, 24)
#
#	simulator.click_left_at($Ref/Square24.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_all_marked_numbers().size(), 0)
#	assert_eq(field.queries.get_highlighted_number_square(), null)
#
#
#func test_create_and_delete_counters():
#	simulator.click_left_at($Ref/CreateCounter.position)
#	simulator.click_left_at($Ref/Square1.position)
#	simulator.click_left_at($Ref/Square2.position)
#	simulator.click_left_at($Ref/Square24.position)
#	simulator.click_left_at($Ref/Square24.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_counter_list().size(), 3)
#	assert_eq(field.queries.get_all_marked_numbers().size(), 3)
#
#	simulator.click_left_at($Ref/DeleteCounter.position)
#	simulator.click_left_at($Ref/Square1.position)
#	simulator.click_left_at($Ref/Square24.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_counter_list().size(), 1)
#	assert_eq(field.queries.get_all_marked_numbers().size(), 1)


func test_interfield_move_counters():
	simulator.click_left_at($Ref/CreateCounter.position)
	simulator.click_left_at($Ref/Square1.position)
	simulator.click_left_at($Ref/Square2.position)
	simulator.click_left_at($Ref/Square3.position)
	simulator.click_left_at($Ref/DragCounter.position)
	simulator.drag_left_between($Ref/Square1.position, $Ref/Square20.position)
	simulator.drag_left_between($Ref/Square2.position, $Ref/Square2.position)
	simulator.drag_left_between($Ref/Square2.position, $Ref/Square3.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_all_marked_numbers(), [2, 3, 20])

	simulator.drag_left_between($Ref/Square2.position, $Ref/MissBoard.position)
	simulator.drag_left_between($Ref/Square3.position, $Ref/MissPim.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_all_marked_numbers(), [20])


func test_create_counters_by_spawner():
	simulator.drag_left_between($Ref/CounterSpawner.position, $Ref/Square1.position)
	simulator.drag_left_between($Ref/CounterSpawner.position, $Ref/Square2.position)
	simulator.drag_left_between($Ref/CounterSpawner.position, $Ref/Square2.position)
	simulator.drag_left_between($Ref/CounterSpawner.position, $Ref/MissBoard.position)
	simulator.drag_left_between($Ref/CounterSpawner.position, $Ref/MissPim.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_counter_list().size(), 2)
	assert_eq(field.queries.get_all_marked_numbers(), [1, 2])
