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
const INITIAL_POSITION := Vector2(50, 50)


func before():
	Game.debug.set_fast_testing()


func test_1():
	Game.debug.add_ref_scene(self, REF_SCENES[1])
	var runner := scene_runner(LEVEL_SCENES["1.1"])
	var program = runner.get_property("_program")
	runner.set_time_factor(100)

	runner.set_mouse_pos(INITIAL_POSITION)
	await await_millis(1000) # Improves reliability for some reason
	await runner.simulate_mouse_move_absolute($Ref/Square5.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Counter.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square6.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Counter.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square7.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Counter.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square8.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await assert_signal(program).is_emitted("level_completed")


func test_5_1():
	Game.debug.add_ref_scene(self, REF_SCENES[5])
	var runner := scene_runner(LEVEL_SCENES["5.1"])
	var program = runner.get_property("_program")
	runner.set_time_factor(100)

	runner.set_mouse_pos(INITIAL_POSITION)
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
	await assert_signal(program).is_emitted("level_completed")


func test_5_2():
	Game.debug.add_ref_scene(self, REF_SCENES[5])
	var runner := scene_runner(LEVEL_SCENES["5.2"])
	var program = runner.get_property("_program")
	runner.set_time_factor(100)

	runner.set_mouse_pos(INITIAL_POSITION)
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
	await assert_signal(program).is_emitted("level_completed")


func test_5_3():
	Game.debug.add_ref_scene(self, REF_SCENES[5])
	var runner := scene_runner(LEVEL_SCENES["5.3"])
	var program = runner.get_property("_program")
	runner.set_time_factor(100)

	runner.set_mouse_pos(INITIAL_POSITION)
	await runner.simulate_mouse_move_absolute($Ref/Square19.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square29.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square39.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await assert_signal(program).is_emitted("level_completed")
