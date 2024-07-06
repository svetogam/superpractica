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

const SCENE_PATH := "res://core/level_select/level_select_screen.tscn"
const REF_SCENE := "res://core/level_select/tests/reference/level_select_ref.tscn"
const TOPIC_1_PATH := "res://core/level_select/tests/topic_data/topic_1.gd"
const TOPIC_2_PATH := "res://core/level_select/tests/topic_data/topic_2.gd"
const TOPIC_4_PATH := "res://core/level_select/tests/topic_data/topic_4.gd"
const TOPIC_1_LEVEL_ID := "dummy_level_1_1"
const TOPIC_2_LEVEL_ID := "dummy_level_2_1"
const TOPIC_4_LEVEL_ID := "dummy_level_4_1"


func before():
	Game.debug.set_testing_preset(GameDebug.TestingPresets.SPEED)
	Game.debug.add_ref_scene(self, REF_SCENE)


func before_test():
	Game.root_topic = preload("topic_data/topic_1.gd").topic
	Game.current_level = null


func after():
	Game.root_topic = null
	Game.current_level = null


func test_enter_level_directly() -> void:
	var scene = auto_free(load(SCENE_PATH).instantiate())
	monitor_signals(scene)
	var runner := scene_runner(scene)
	runner.set_time_factor(100)
	var level_data = load(TOPIC_1_PATH).topic.get_level([TOPIC_1_LEVEL_ID])

	await runner.simulate_mouse_move_absolute($Ref/Topic1View1/Level1_1.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.await_signal("zoomed_in")
	await runner.simulate_mouse_move_absolute($Ref/LevelFocus/Inside.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await assert_signal(scene).is_emitted("level_entered", [level_data])


func test_enter_topic_then_topic_then_level() -> void:
	var scene = auto_free(load(SCENE_PATH).instantiate())
	monitor_signals(scene)
	var runner := scene_runner(scene)
	runner.set_time_factor(100)
	var level_data = load(TOPIC_4_PATH).topic.get_level([TOPIC_4_LEVEL_ID])

	await runner.simulate_mouse_move_absolute($Ref/Topic1View1/Topic3.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.await_signal("zoomed_in")
	await runner.simulate_mouse_move_absolute($Ref/TopicFocus/Inside.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	#await runner.await_signal("zoomed_in") # Immediate for now
	await runner.simulate_mouse_move_absolute($Ref/Topic3/Topic4.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.await_signal("zoomed_in")
	await runner.simulate_mouse_move_absolute($Ref/TopicFocus/Inside.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	#await runner.await_signal("zoomed_in") # Immediate for now
	await runner.simulate_mouse_move_absolute($Ref/Topic4/Level4_1.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.await_signal("zoomed_in")
	await runner.simulate_mouse_move_absolute($Ref/LevelFocus/Inside.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await assert_signal(scene).is_emitted("level_entered", [level_data])


func test_enter_topic_then_back_then_different_topic_then_level() -> void:
	var scene = auto_free(load(SCENE_PATH).instantiate())
	monitor_signals(scene)
	var runner := scene_runner(scene)
	runner.set_time_factor(100)
	var level_data = load(TOPIC_2_PATH).topic.get_level([TOPIC_2_LEVEL_ID])

	await runner.simulate_mouse_move_absolute($Ref/Topic1View1/Topic3.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.await_signal("zoomed_in")
	await runner.simulate_mouse_move_absolute($Ref/TopicFocus/Inside.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	#await runner.await_signal("zoomed_in") # Immediate for now
	await runner.simulate_mouse_move_absolute($Ref/BackButton.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	#await runner.await_signal("zoomed_out") # Immediate for now
	await runner.simulate_mouse_move_absolute($Ref/BackButton.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.await_signal("zoomed_out")
	await runner.simulate_mouse_move_absolute($Ref/Topic1View2/Topic2.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.await_signal("zoomed_in")
	await runner.simulate_mouse_move_absolute($Ref/TopicFocus/Inside.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	#await runner.await_signal("zoomed_in") # Immediate for now
	await runner.simulate_mouse_move_absolute($Ref/Topic2/Level2_1.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await runner.await_signal("zoomed_in")
	await runner.simulate_mouse_move_absolute($Ref/LevelFocus/Inside.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	await assert_signal(scene).is_emitted("level_entered", [level_data])


func test_exit_to_main_menu() -> void:
	var scene = auto_free(load(SCENE_PATH).instantiate())
	monitor_signals(scene)
	var runner := scene_runner(scene)
	runner.set_time_factor(100)

	await runner.simulate_mouse_move_absolute($Ref/MenuButton.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	# Wait here if not immediate
	await runner.simulate_mouse_move_absolute($Ref/Menu/ExitButton.position, 0.01)
	runner.simulate_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	# Wait here if not immediate
	await assert_signal(scene).is_emitted("exit_pressed")
