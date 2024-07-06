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

const TOPIC_DATA = preload("res://content/debug/levels/sum_problems/topic_data.gd").topic
const LEVEL_NAMES := {
	"1.1": "debug_1_1_1",
	"5.1": "debug_1_5_1",
	"5.2": "debug_1_5_2",
	"5.3": "debug_1_5_3",
}
const LEVEL_SCENES := {
	"1.1": "res://content/debug/levels/sum_problems/basic_addition_1/levels/level_1.tscn",
	"5.1": "res://content/debug/levels/sum_problems/basic_addition_5/levels/level_1.tscn",
	"5.2": "res://content/debug/levels/sum_problems/basic_addition_5/levels/level_2.tscn",
	"5.3": "res://content/debug/levels/sum_problems/basic_addition_5/levels/level_3.tscn",
}
const REF_SCENES := {
	1: "res://content/debug/levels/sum_problems/tests/sum_problem_1_ref.tscn",
	5: "res://content/debug/levels/sum_problems/tests/sum_problem_5_ref.tscn",
}


func before():
	Game.debug.set_testing_preset(GameDebug.TestingPresets.RELIABILITY)


func before_test():
	Game.current_level = null
	Game.progress_data.clear()


func after():
	Game.current_level = null
	Game.progress_data.clear()


func test_1():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES["1.1"]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENES[1])
	var runner := scene_runner(LEVEL_SCENES["1.1"])
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square5.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square6.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square7.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square8.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)

	await await_idle_frame()
	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_5_1():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES["5.1"]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENES[5])
	var runner := scene_runner(LEVEL_SCENES["5.1"])
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square4.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square14.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square24.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square25.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square26.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square27.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	await await_idle_frame()
	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_5_2():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES["5.2"]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENES[5])
	var runner := scene_runner(LEVEL_SCENES["5.2"])
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square35.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square36.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square37.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square38.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square39.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square40.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square41.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square42.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	await await_idle_frame()
	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_5_3():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES["5.2"]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENES[5])
	var runner := scene_runner(LEVEL_SCENES["5.3"])
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square19.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square29.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square39.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)

	await await_idle_frame()
	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()
