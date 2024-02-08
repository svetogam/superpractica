#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends SpLevelTest

const LEVEL_GROUP := "sum_problems"
const REF_SCENES := {
	1: "res://content/basic_addition/tests/task_levels/sum_problem_1_ref.tscn",
	2: "res://content/basic_addition/tests/task_levels/sum_problem_2_ref.tscn",
	3: "res://content/basic_addition/tests/task_levels/sum_problem_3_ref.tscn",
	4: "res://content/basic_addition/tests/task_levels/sum_problem_4_ref.tscn",
	5: "res://content/basic_addition/tests/task_levels/sum_problem_5_ref.tscn",
	6: "res://content/basic_addition/tests/task_levels/sum_problem_6_ref.tscn",
	7: "res://content/basic_addition/tests/task_levels/sum_problem_7_ref.tscn",
	8: "res://content/basic_addition/tests/task_levels/sum_problem_8_ref.tscn",
}


func test_1():
	_load_level(LEVEL_GROUP, "1.1")
	_load_ref_scene(REF_SCENES[1])

	simulator.click_left_at($Ref/Square5.position)
	#simulator.drag_left_between($Ref/Counter.position, $Ref/Square6.position)
	#simulator.drag_left_between($Ref/Counter.position, $Ref/Square7.position)
	#simulator.drag_left_between($Ref/Counter.position, $Ref/Square8.position)
	# Cannot drag due to temporary interface bugs
	simulator.click_left_at($Ref/Counter.position)
	simulator.click_left_at($Ref/Square6.position)
	simulator.click_left_at($Ref/Counter.position)
	simulator.click_left_at($Ref/Square7.position)
	simulator.click_left_at($Ref/Counter.position)
	simulator.click_left_at($Ref/Square8.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_2():
	_load_level(LEVEL_GROUP, "2.1")
	_load_ref_scene(REF_SCENES[2])

	simulator.click_left_at($Ref/Square5.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.task_completed, _get_await_time())
	assert_signal_emitted(program, "task_completed")

	#simulator.drag_left_between($Ref/Counter.position, $Ref/Square6.position)
	#simulator.drag_left_between($Ref/Counter.position, $Ref/Square7.position)
	#simulator.drag_left_between($Ref/Counter.position, $Ref/Square8.position)
	# Cannot drag due to temporary interface bugs
	simulator.click_left_at($Ref/Counter.position)
	simulator.click_left_at($Ref/Square6.position)
	simulator.click_left_at($Ref/Counter.position)
	simulator.click_left_at($Ref/Square7.position)
	simulator.click_left_at($Ref/Counter.position)
	simulator.click_left_at($Ref/Square8.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.task_completed, _get_await_time())
	assert_signal_emitted(program, "task_completed")

	simulator.drag_left_between($Ref/Square8.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.task_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_3():
	_load_level(LEVEL_GROUP, "3.1")
	_load_ref_scene(REF_SCENES[3])

	simulator.click_left_at($Ref/IncrementButton.position, 8)
	simulator.drag_left_between($Ref/SelectorSlot.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_4():
	_load_level(LEVEL_GROUP, "4.1")
	_load_ref_scene(REF_SCENES[4])

	simulator.click_left_at($Ref/IncrementButton.position, 8)
	simulator.drag_left_between($Ref/SelectorSlot.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_5_1():
	_load_level(LEVEL_GROUP, "5.1")
	_load_ref_scene(REF_SCENES[5])

	simulator.click_left_at($Ref/Square4.position)
	simulator.click_left_at($Ref/Square14.position)
	simulator.click_left_at($Ref/Square24.position)
	simulator.click_left_at($Ref/Square25.position)
	simulator.click_left_at($Ref/Square26.position)
	simulator.click_left_at($Ref/Square27.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_5_2():
	_load_level(LEVEL_GROUP, "5.2")
	_load_ref_scene(REF_SCENES[5])

	simulator.click_left_at($Ref/Square35.position)
	simulator.click_left_at($Ref/Square36.position)
	simulator.click_left_at($Ref/Square37.position)
	simulator.click_left_at($Ref/Square38.position)
	simulator.click_left_at($Ref/Square39.position)
	simulator.click_left_at($Ref/Square40.position)
	simulator.click_left_at($Ref/Square41.position)
	simulator.click_left_at($Ref/Square42.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_5_3():
	_load_level(LEVEL_GROUP, "5.3")
	_load_ref_scene(REF_SCENES[5])

	simulator.click_left_at($Ref/Square19.position)
	simulator.click_left_at($Ref/Square29.position)
	simulator.click_left_at($Ref/Square39.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_6_1():
	_load_level(LEVEL_GROUP, "6.1")
	_load_ref_scene(REF_SCENES[6])

	simulator.click_left_at($Ref/Square4.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.task_completed, _get_await_time())
	assert_signal_emitted(program, "task_completed")

	simulator.click_left_at($Ref/Square14.position)
	simulator.click_left_at($Ref/Square24.position)
	simulator.click_left_at($Ref/Square25.position)
	simulator.click_left_at($Ref/Square26.position)
	simulator.click_left_at($Ref/Square27.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.task_completed, _get_await_time())
	assert_signal_emitted(program, "task_completed")

	simulator.drag_left_between($Ref/Square27.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_6_2():
	_load_level(LEVEL_GROUP, "6.2")
	_load_ref_scene(REF_SCENES[6])

	simulator.click_left_at($Ref/Square35.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.task_completed, _get_await_time())
	assert_signal_emitted(program, "task_completed")

	simulator.click_left_at($Ref/Square36.position)
	simulator.click_left_at($Ref/Square37.position)
	simulator.click_left_at($Ref/Square38.position)
	simulator.click_left_at($Ref/Square39.position)
	simulator.click_left_at($Ref/Square40.position)
	simulator.click_left_at($Ref/Square41.position)
	simulator.click_left_at($Ref/Square42.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.task_completed, _get_await_time())
	assert_signal_emitted(program, "task_completed")

	simulator.drag_left_between($Ref/Square42.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_6_3():
	_load_level(LEVEL_GROUP, "6.3")
	_load_ref_scene(REF_SCENES[6])

	simulator.click_left_at($Ref/Square19.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.task_completed, _get_await_time())
	assert_signal_emitted(program, "task_completed")

	simulator.click_left_at($Ref/Square29.position)
	simulator.click_left_at($Ref/Square39.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.task_completed, _get_await_time())
	assert_signal_emitted(program, "task_completed")

	simulator.drag_left_between($Ref/Square39.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_7_1():
	_load_level(LEVEL_GROUP, "7.1")
	_load_ref_scene(REF_SCENES[7])

	simulator.drag_left_between($Ref/Square27.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_7_2():
	_load_level(LEVEL_GROUP, "7.2")
	_load_ref_scene(REF_SCENES[7])

	simulator.drag_left_between($Ref/Square42.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_7_3():
	_load_level(LEVEL_GROUP, "7.3")
	_load_ref_scene(REF_SCENES[7])

	simulator.drag_left_between($Ref/Square39.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")


func test_8():
	_load_level(LEVEL_GROUP, "8.1")
	_load_ref_scene(REF_SCENES[8])

	simulator.click_left_at($Ref/Button2.position)
	simulator.click_left_at($Ref/Button7.position)
	simulator.drag_left_between($Ref/SelectorSlot.position, $Ref/SumSlot.position)
	simulator.click_left_at($Ref/CheckButton.position)
	simulator.run()
	await wait_for_signal(program.level_completed, _get_await_time())
	assert_signal_emitted(program, "level_completed")
