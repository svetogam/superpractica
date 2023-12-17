#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GameDebug
extends RefCounted

enum TimeScales {
	SLOW,
	NORMAL,
	FASTEST,
}
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

var _on := false
var _animation_time_modifier: float
var _skip_delays: bool
var _delay_time_modifier: float


func set_on(value := true) -> void:
	if value:
		_on = true
	else:
		_on = false
		set_time_scale(TimeScales.NORMAL)
		enable_precise_input(false)
		disable_graphics(false)


func set_time_scale(time_scale: int) -> void:
	if _on:
		match time_scale:
			TimeScales.SLOW:
				Engine.time_scale = 0.5
			TimeScales.NORMAL:
				Engine.time_scale = 1.0
			TimeScales.FASTEST:
				Engine.time_scale = 100.0


func enable_precise_input(enable := true) -> void:
	if _on:
		Input.use_accumulated_input = not enable


func disable_graphics(disable := true) -> void:
	if _on:
		RenderingServer.render_loop_enabled = not disable


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


#====================================================================
# Logging
#====================================================================

func warn(message: String) -> void:
	if _on:
		print(message)
