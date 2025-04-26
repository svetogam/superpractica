# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends GdUnitTestSuite

const TOPIC_DATA = preload("uid://ci15tg7x5cpto").topic
const LEVEL_NAMES := {
	1: "select_number_1",
	2: "select_number_2",
}
const LEVEL_SCENE := "res://core/screens/pimnet_level/pimnet_level_screen.tscn"
const REF_SCENE := (
		"res://content/debug/levels/number_selectors/tests/number_selectors_ref.tscn")


func before():
	Game.debug.set_testing_preset(GameDebug.TestingPresets.SPEED)
	Game.debug.add_ref_scene(self, REF_SCENE)


func before_each():
	Game.progress_data.clear()


func after():
	Game.progress_data.clear()


func test_selector_1():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[1]])
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Selector1/PlusButton.position, 0.01)
	for _i in range(8):
		runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Selector1/SelectorSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Selector1/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_selector_2():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[2]])
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Selector2/Num2Button.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Selector2/Num7Button.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Selector2/SelectorSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Selector2/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()
