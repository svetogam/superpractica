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

const TOPIC_DATA: TopicResource = preload(
		"res://content/packs/basic_addition/levels/grid_counting/topic_data.gd").topic
const LEVEL_NAMES := {
	1: "grid_counting_0_1",
	2: "grid_counting_0_2",
}
const LEVEL_SCENE := "res://core/screens/pimnet_level/pimnet_level_screen.tscn"
const REF_SCENE := ("res://content/packs/basic_addition/levels/grid_counting/"
		+ "tests/screen_ref_de.tscn")


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

func test_golden_path_0_1():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[1]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square5.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_0_2():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[2]])
	Game.current_level = level_data
	Game.debug.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square1.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()
