##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name GameDebug
extends Reference

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
var _delay_timer_type: String
var _delay_time_modifier: float


func set_on(value:=true) -> void:
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


func enable_precise_input(enable:=true) -> void:
	if _on:
		Input.use_accumulated_input = not enable


func disable_graphics(disable:=true) -> void:
	if _on:
		VisualServer.render_loop_enabled = not disable


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
			_delay_timer_type = "timeout"
		DelayTimes.SHORTER:
			_skip_delays = false
			_delay_time_modifier = 0.5
			_delay_timer_type = "timeout"
		DelayTimes.FRAME:
			_skip_delays = false
			_delay_time_modifier = 0.01
			_delay_timer_type = "next_idle"
		DelayTimes.SKIP:
			_skip_delays = true
			_delay_time_modifier = 0.01
			_delay_timer_type = "next_idle"
		_:
			assert(false)


func is_on() -> bool:
	return _on


func get_animation_time_modifier() -> float:
	return _animation_time_modifier


func create_wait_timer(time: float) -> Timer:
	return Utils.create_wait_timer(_delay_timer_type, time * _delay_time_modifier)


func should_skip_delays() -> bool:
	return _skip_delays


#####################################################################
# Logging
#####################################################################

func warn(message: String) -> void:
	if _on:
		print(message)
