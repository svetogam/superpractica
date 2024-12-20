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

const VERIFICATION_TIMEOUT: int = 4000
const TOPIC_DATA: TopicResource = preload(
		"res://content/packs/basic_addition/levels/grid_counting/topic_data.gd").topic
const LEVEL_NAMES := {
	1: "grid_counting_4_1",
	2: "grid_counting_4_2",
	3: "grid_counting_4_3",
	4: "grid_counting_4_4",
	5: "grid_counting_4_5",
	6: "grid_counting_4_6",
}
const LEVEL_SCENE := "res://core/screens/pimnet_level/pimnet_level_screen.tscn"
const REF_SCENE := ("res://content/packs/basic_addition/levels/grid_counting/"
		+ "tests/screen_ref_g.tscn")


func before():
	Game.debug.set_testing_preset(GameDebug.TestingPresets.RELIABILITY)


func before_test():
	Game.current_level = null
	Game.progress_data.clear()


func after():
	Game.current_level = null
	Game.progress_data.clear()


#====================================================================
# Golden Path
#====================================================================

func test_golden_path_4_1():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[1]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square7.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block3.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square9.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block5.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square13.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()

func test_golden_path_4_2():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[2]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square20.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block30.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square31.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_4_3():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[3]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square19.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square20.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block5.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square23.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block3.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square27.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_4_4():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[4]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square30.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block30.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square41.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block5.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square63.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_4_5():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[5]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square29.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square30.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block20.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square31_41.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square51.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_4_6():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[6]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square37.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block3.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square39.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Block50.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square61.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()
