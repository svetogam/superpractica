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

const LEVEL_GROUP := "pie_slicer_tasks"
const REF_SCENES := {
	1: "res://content/basic_fractions/tests/task_levels/pie_slicer_1_ref.tscn",
	2: "res://content/basic_fractions/tests/task_levels/pie_slicer_2_ref.tscn",
	3: "res://content/basic_fractions/tests/task_levels/pie_slicer_3_ref.tscn",
}


func test_pie_slicer_1_1():
	_load_level(LEVEL_GROUP, "1.1")
	_load_ref_scene(REF_SCENES[1])

	simulator.click_left_at($Ref/IncrButton.position)
	simulator.drag_left_between($Ref/SelectorSlot.position, $Ref/NumeratorSlot.position)
	simulator.click_left_at($Ref/IncrButton.position)
	simulator.drag_left_between($Ref/SelectorSlot.position, $Ref/DenominatorSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	yield(yield_to(level, "level_completed", _get_yield_wait()), YIELD)

	assert_signal_emitted(level, "level_completed")


func test_pie_slicer_1_2():
	_load_level(LEVEL_GROUP, "1.2")
	_load_ref_scene(REF_SCENES[1])

	simulator.click_left_at($Ref/IncrButton.position, 4)
	simulator.drag_left_between($Ref/SelectorSlot.position, $Ref/NumeratorSlot.position)
	simulator.click_left_at($Ref/IncrButton.position, 2)
	simulator.drag_left_between($Ref/SelectorSlot.position, $Ref/DenominatorSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	yield(yield_to(level, "level_completed", _get_yield_wait()), YIELD)

	assert_signal_emitted(level, "level_completed")


func test_pie_slicer_2_1():
	_load_level(LEVEL_GROUP, "2.1")
	_load_ref_scene(REF_SCENES[2])

	simulator.click_left_at($Ref/AddSlice.position)
	simulator.click_left_at($Ref/Slice1.position)
	simulator.click_left_at($Ref/Slice2.position)
	simulator.click_left_at($Ref/Slice3.position)
	simulator.click_left_at($Ref/Slice4.position)
	simulator.click_left_at($Ref/Slice5.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	yield(yield_to(level, "level_completed", _get_yield_wait()), YIELD)

	assert_signal_emitted(level, "level_completed")


func test_pie_slicer_3_1():
	_load_level(LEVEL_GROUP, "3.1")
	_load_ref_scene(REF_SCENES[3])

	simulator.click_left_at($Ref/Slice1.position)
	simulator.click_left_at($Ref/Slice2.position)
	simulator.click_left_at($Ref/Slice3.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	yield(yield_to(level, "task_completed", _get_yield_wait()), YIELD)
	assert_signal_emitted(level, "task_completed")

	simulator.click_left_at($Ref/Region1.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	yield(yield_to(level, "level_completed", _get_yield_wait()), YIELD)
	assert_signal_emitted(level, "level_completed")
