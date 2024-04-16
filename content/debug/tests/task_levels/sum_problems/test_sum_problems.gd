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

const LEVEL_SCENES := {
	"1.1": "res://content/debug/levels/sum_problems/basic_addition_1/levels/level_1.tscn",
	"5.1": "res://content/debug/levels/sum_problems/basic_addition_5/levels/level_1.tscn",
	"5.2": "res://content/debug/levels/sum_problems/basic_addition_5/levels/level_2.tscn",
	"5.3": "res://content/debug/levels/sum_problems/basic_addition_5/levels/level_3.tscn",
}
const REF_SCENES := {
	1: "res://content/debug/tests/task_levels/sum_problems/sum_problem_1_ref.tscn",
	5: "res://content/debug/tests/task_levels/sum_problems/sum_problem_5_ref.tscn",
}


# Tests are broken. (2024.4.9)
# Tests 5_1, 5_2, and 5_3 pass individually, but do not reliably
# pass when running together.
# Test 1 does not pass individually.
# Waiting for 0.1 seconds at the start is to wait for the camera to
# initially adjust in the pimnet.

#func test_1():
	#_load_level(LEVEL_SCENES["1.1"])
	#_load_ref_scene(REF_SCENES[1])
#
	#await wait_seconds(0.1)
#
	#simulator.click_left_at($Ref/Square5.position)
	#simulator.drag_left_between($Ref/Counter.position, $Ref/Square6.position)
	#simulator.drag_left_between($Ref/Counter.position, $Ref/Square7.position)
	#simulator.drag_left_between($Ref/Counter.position, $Ref/Square8.position)
	#simulator.run()
	#await wait_for_signal(program.level_completed, _get_await_time())
	#assert_signal_emitted(program, "level_completed")
#
#
#func test_5_1():
	#_load_level(LEVEL_SCENES["5.1"])
	#_load_ref_scene(REF_SCENES[5])
#
	#await wait_seconds(0.1)
#
	#simulator.click_left_at($Ref/Square4.position)
	#simulator.click_left_at($Ref/Square14.position)
	#simulator.click_left_at($Ref/Square24.position)
	#simulator.click_left_at($Ref/Square25.position)
	#simulator.click_left_at($Ref/Square26.position)
	#simulator.click_left_at($Ref/Square27.position)
	#simulator.run()
	#await wait_for_signal(program.level_completed, _get_await_time())
	#assert_signal_emitted(program, "level_completed")
#
#
#func test_5_2():
	#_load_level(LEVEL_SCENES["5.2"])
	#_load_ref_scene(REF_SCENES[5])
#
	#await wait_seconds(0.1)
#
	#simulator.click_left_at($Ref/Square35.position)
	#simulator.click_left_at($Ref/Square36.position)
	#simulator.click_left_at($Ref/Square37.position)
	#simulator.click_left_at($Ref/Square38.position)
	#simulator.click_left_at($Ref/Square39.position)
	#simulator.click_left_at($Ref/Square40.position)
	#simulator.click_left_at($Ref/Square41.position)
	#simulator.click_left_at($Ref/Square42.position)
	#simulator.run()
	#await wait_for_signal(program.level_completed, _get_await_time())
	#assert_signal_emitted(program, "level_completed")
#
#
#func test_5_3():
	#_load_level(LEVEL_SCENES["5.3"])
	#_load_ref_scene(REF_SCENES[5])
#
	#await wait_seconds(0.1)
#
	#simulator.click_left_at($Ref/Square19.position)
	#simulator.click_left_at($Ref/Square29.position)
	#simulator.click_left_at($Ref/Square39.position)
	#simulator.run()
	#await wait_for_signal(program.level_completed, _get_await_time())
	#assert_signal_emitted(program, "level_completed")
