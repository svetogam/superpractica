# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name GameDebug
extends RefCounted

enum AnimationSpeeds {
	NORMAL,
	FASTER,
	INSTANT,
}
enum DelayTimes {
	NORMAL,
	SHORTER,
	FRAME,
	SKIP,
}
enum TestingPresets {
	SPEED,
	RELIABILITY,
	VISIBILITY,
}

const TIME_SCALE_SLOW := 0.5
const TIME_SCALE_NORMAL := 1.0
const TIME_SCALE_FASTEST := 100.0
var fallback_screen_rect: Rect2:
	get = get_fallback_screen_rect
var _on := false
var _animation_time_modifier: float
var _skip_delays: bool
var _delay_time_modifier: float


func set_on(value := true) -> void:
	if value:
		_on = true
	else:
		_on = false
		Engine.time_scale = TIME_SCALE_NORMAL
		Input.use_accumulated_input = true
		RenderingServer.render_loop_enabled = true


# Disabling accumulated input should improve reliability, but this hasn't been verified
# Disabling graphics increases speed, but decreases visibility and reliability
func set_testing_preset(preset: int) -> void:
	match preset:
		TestingPresets.SPEED:
			set_on()
			Engine.time_scale = TIME_SCALE_FASTEST
			Input.use_accumulated_input = false
			RenderingServer.render_loop_enabled = false
			set_animation_speed(AnimationSpeeds.INSTANT)
			set_delay_speed(DelayTimes.SKIP)
		TestingPresets.RELIABILITY:
			set_on()
			Engine.time_scale = TIME_SCALE_NORMAL
			Input.use_accumulated_input = false
			RenderingServer.render_loop_enabled = true
			set_animation_speed(AnimationSpeeds.INSTANT)
			set_delay_speed(DelayTimes.FRAME)
		TestingPresets.VISIBILITY:
			set_on()
			Engine.time_scale = TIME_SCALE_SLOW
			Input.use_accumulated_input = true
			RenderingServer.render_loop_enabled = true
			set_animation_speed(AnimationSpeeds.NORMAL)
			set_delay_speed(DelayTimes.NORMAL)
		_:
			assert(false)


func set_animation_speed(animation_speed: int) -> void:
	match animation_speed:
		AnimationSpeeds.NORMAL:
			_animation_time_modifier = 1.0
		AnimationSpeeds.FASTER:
			_animation_time_modifier = 0.5
		AnimationSpeeds.INSTANT:
			_animation_time_modifier = 0.0
		_:
			assert(false)


func set_delay_speed(delay_speed: int) -> void:
	match delay_speed:
		DelayTimes.NORMAL:
			_skip_delays = false
			_delay_time_modifier = 1.0
		DelayTimes.SHORTER:
			_skip_delays = false
			_delay_time_modifier = 0.5
		DelayTimes.FRAME:
			_skip_delays = false
			_delay_time_modifier = 0.01
		DelayTimes.SKIP:
			_skip_delays = true
			_delay_time_modifier = 0.01
		_:
			assert(false)


func is_on() -> bool:
	return _on


func get_animation_time_modifier() -> float:
	return _animation_time_modifier


func debug_wait_for(time: float):
	if _skip_delays or time <= 0:
		return null
	else:
		var wait_timer = Game.get_tree().create_timer(
				time * _delay_time_modifier)
		return wait_timer.timeout


func should_skip_delays() -> bool:
	return _skip_delays


func get_fallback_screen_rect() -> Rect2:
	return Rect2(0, 0, ProjectSettings.get_setting("display/window/size/viewport_width"),
			ProjectSettings.get_setting("display/window/size/viewport_height"))


func warn(message: String) -> void:
	if _on:
		print(message)


static func add_ref_scene(test_suite: GdUnitTestSuite, scene_path: String) -> Node:
	var ref_scene = test_suite.auto_free(load(scene_path).instantiate())
	test_suite.add_child(ref_scene)
	for child in ref_scene.get_children():
		if child is CanvasItem:
			child.hide()
	return ref_scene


# Requires rewriting
#func save_failure_screenshot(output_path: String) -> void:
	#if is_failing():
		#var source = get_stack()[1]["source"]
		#source = source.trim_suffix(".gd")
		#source = source.rsplit("/", false, 1)[1]
		#var line = get_stack()[1]["line"]
		#var filename = output_path + source + "-line-" + str(line) + ".png"
		#var image := get_viewport().get_texture().get_image()
		#image.save_png(filename)
