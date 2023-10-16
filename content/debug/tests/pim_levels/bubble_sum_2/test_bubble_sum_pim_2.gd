##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends SpLevelTest

var field_1: Field
var field_2: Field


func before_each():
	.before_each()
	_load_level("debug_windows", "bubble_sum_2")
	_load_ref_scene("res://content/debug/tests/pim_levels/bubble_sum_2/bubble_sum_2_pim_ref.tscn")
	field_1 = pimnet.get_pim("BubbleSumPim1").field
	field_2 = pimnet.get_pim("BubbleSumPim2").field


func test_move_units_between_fields():
	simulator.click_left_at($Ref/CreateUnit1.position)
	simulator.click_left_at($Ref/UnitPlace1_1.position)
	simulator.click_left_at($Ref/UnitPlace1_2.position)
	simulator.click_left_at($Ref/MoveObject1.position)
	simulator.drag_left_between($Ref/UnitPlace1_1.position, $Ref/UnitPlace2_1.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field_1.queries.get_unit_list().size(), 1)
	assert_eq(field_2.queries.get_unit_list().size(), 1)

	simulator.click_left_at($Ref/MoveObject2.position)
	simulator.drag_left_between($Ref/UnitPlace2_1.position, $Ref/UnitPlace1_1.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field_1.queries.get_unit_list().size(), 2)
	assert_eq(field_2.queries.get_unit_list().size(), 0)

	simulator.click_left_at($Ref/Undo.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field_1.queries.get_unit_list().size(), 1)
	assert_eq(field_2.queries.get_unit_list().size(), 1)

	simulator.click_left_at($Ref/Undo.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field_1.queries.get_unit_list().size(), 2)
	assert_eq(field_2.queries.get_unit_list().size(), 0)


func test_move_units_off_field():
	simulator.click_left_at($Ref/CreateUnit1.position)
	simulator.click_left_at($Ref/UnitPlace1_1.position)
	simulator.click_left_at($Ref/UnitPlace1_2.position)
	simulator.click_left_at($Ref/MoveObject1.position)
	simulator.drag_left_between($Ref/UnitPlace1_1.position, $Ref/MissPims.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field_1.queries.get_unit_list().size(), 1)
