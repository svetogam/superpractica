# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends GdUnitTestSuite

const VERIFICATION_TIMEOUT: int = 4000
const TOPIC_DATA: TopicResource = preload("uid://08dpfdxntkc0").grid_counting_topic
const LEVEL_NAMES := {
	1: "grid_counting_3_1",
	2: "grid_counting_3_2",
	3: "grid_counting_3_3",
	4: "grid_counting_3_4",
	5: "grid_counting_3_5",
	6: "grid_counting_3_6",
}
const LEVEL_SCENE := "res://core/screens/pimnet_level/pimnet_level_screen.tscn"
const REF_SCENE := ("res://content/packs/basic_addition/levels/grid_counting/"
		+ "tests/screen_ref_c.tscn")


func before():
	Game.debug.set_testing_preset(GameDebug.TestingPresets.RELIABILITY)


func before_test():
	Game.progress_data.clear()


func after():
	Game.progress_data.clear()


#====================================================================
# Golden Path
#====================================================================

func test_golden_path_3_1():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[1]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square2.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square3.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_3_2():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[2]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square4.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square5.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
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
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_3_3():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[3]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square8.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square9.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square10.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square11.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_3_4():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[4]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square10.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square11.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square12.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square13.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square14.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square15.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square16.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_3_5():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[5]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square39.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square40.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square41.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_3_6_with_mark():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[6]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square1.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_golden_path_3_6_with_unit():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[6]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square1.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


#====================================================================
# Borderline Success
#====================================================================

func test_complete_if_corrected_after_failure():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[2]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	# Stop one short of correct number of units
	await runner.simulate_mouse_move_absolute($Ref/Square4.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square5.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square6.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square7.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await await_millis(VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_false()

	# Place remaining unit
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square8.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_complete_if_addends_to_mark_and_count_are_inefficiently_chosen():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[3]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square3.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square4.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square5.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
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
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square9.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square10.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square11.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


func test_complete_if_field_is_marked_in_the_opposite_order():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[3]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square11.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square10.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square9.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square8.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.await_signal_on(
			runner.scene().program, "level_completed", [], VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_true()


#====================================================================
# Borderline Failure
#====================================================================

func test_do_not_complete_if_solution_is_reached_by_adding_units_alone():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[1]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square1.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square2.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square3.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await await_millis(VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_false()


func test_do_not_complete_if_solution_is_marked_with_no_units():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[2]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square8.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await await_millis(VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_false()


func test_do_not_complete_if_units_start_on_marked_square():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[2]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square4.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square4.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square5.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square6.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square7.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await await_millis(VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_false()


func test_do_not_complete_if_junk_gives_a_warning():
	var level_data := TOPIC_DATA.get_level([LEVEL_NAMES[1]])
	TestingUtils.add_ref_scene(self, REF_SCENE)
	var runner := scene_runner(LEVEL_SCENE)
	runner.scene().load_level(level_data)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/Square2.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square3.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Unit.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/Square30.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/OutputSlot.position, 0.01)
	runner.simulate_mouse_button_press(MOUSE_BUTTON_LEFT)
	await runner.simulate_mouse_move_absolute($Ref/GoalSlot.position, 0.01)
	runner.simulate_mouse_button_release(MOUSE_BUTTON_LEFT)
	await await_millis(VERIFICATION_TIMEOUT)

	assert_bool(Game.progress_data.is_level_completed(level_data.id)).is_false()
