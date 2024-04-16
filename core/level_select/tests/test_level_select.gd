#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends SpIntegrationTest

const REF_SCENE := "res://core/level_select/tests/reference/level_select_ref.tscn"


func _get_scene_path() -> String:
	return "res://core/level_select/level_select_screen.tscn"


func before_each():
	Game.root_topic = preload("topic_data/topic_1.gd").topic
	Game.current_level = null
	super()


func test_enter_level_directly() -> void:
	_load_ref_scene(REF_SCENE)

	simulator.click_left_at($Ref/Topic1View1/Level1_1.position)
	simulator.run()
	await wait_for_signal(scene.zoomed_in, _get_await_time())
	assert_signal_emitted(scene, "zoomed_in")
	simulator.click_left_at($Ref/LevelFocus/Inside.position)
	simulator.run()
	await wait_for_signal(scene.level_entered, _get_await_time())

	assert_signal_emit_count(scene, "zoomed_in", 1)
	assert_signal_emit_count(scene, "zoomed_out", 0)
	assert_signal_emitted(scene, "level_entered")
	var parameters = get_signal_parameters(scene, "level_entered")
	assert_true(parameters != null)
	if parameters != null:
		assert_eq(parameters[0].id, "dummy_level_1_1")


# Other tests are broken.

#func test_enter_topic_then_topic_then_level() -> void:
	#_load_ref_scene(REF_SCENE)
#
	#simulator.click_left_at($Ref/Topic1View1/Topic3.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/TopicFocus/Inside.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/Topic3/Topic4.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/TopicFocus/Inside.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/Topic4/Level4_1.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/LevelFocus/Inside.position)
	#simulator.run()
	#await wait_for_signal(scene.level_entered, _get_await_time())
#
	#assert_signal_emit_count(scene, "zoomed_in", 5)
	#assert_signal_emit_count(scene, "zoomed_out", 0)
	#assert_signal_emitted(scene, "level_entered")
	#var parameters = get_signal_parameters(scene, "level_entered")
	#assert_true(parameters != null)
	#if parameters != null:
		#assert_eq(parameters[0].id, "dummy_level_4_1")
#
#
#func test_enter_topic_then_back_then_different_topic_then_level() -> void:
	#_load_ref_scene(REF_SCENE)
#
	#simulator.click_left_at($Ref/Topic1View1/Topic3.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/TopicFocus/Inside.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/BackButton.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_out, _get_await_time())
	#simulator.click_left_at($Ref/BackButton.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_out, _get_await_time())
	#simulator.click_left_at($Ref/Topic1View2/Topic2.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/TopicFocus/Inside.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/Topic2/Level2_1.position)
	#simulator.run()
	#await wait_for_signal(scene.zoomed_in, _get_await_time())
	#simulator.click_left_at($Ref/LevelFocus/Inside.position)
	#simulator.run()
	#await wait_for_signal(scene.level_entered, _get_await_time())
#
	#assert_signal_emit_count(scene, "zoomed_in", 5)
	#assert_signal_emit_count(scene, "zoomed_out", 2)
	#assert_signal_emitted(scene, "level_entered")
	#var parameters = get_signal_parameters(scene, "level_entered")
	#assert_true(parameters != null)
	#if parameters != null:
		#assert_eq(parameters[0].id, "dummy_level_2_1")
#
#
#func test_exit_to_main_menu() -> void:
	#_load_ref_scene(REF_SCENE)
#
	#simulator.click_left_at($Ref/MenuButton.position)
	#simulator.click_left_at($Ref/Menu/ExitButton.position)
	#simulator.run()
	#await wait_for_signal(scene.exit_pressed, _get_await_time())
#
	#assert_signal_emitted(scene, "exit_pressed")
