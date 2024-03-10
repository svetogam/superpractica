#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Node

var root_topic: TopicResource
var progress_data := GameProgressResource.new()
var current_level: LevelResource = null
var debug := GameDebug.new()


#====================================================================
# Speed and Timing
#====================================================================

func call_after(callable: Callable, time_delay: float) -> void:
	if debug.is_on() and debug.should_skip_delays() or time_delay <= 0:
		callable.call()
	else:
		var timer := get_tree().create_timer(time_delay)
		timer.timeout.connect(callable)


func wait_for(time: float):
	if debug.is_on():
		return debug.debug_wait_for(time)
	elif time > 0:
		var wait_timer := get_tree().create_timer(time)
		return wait_timer.timeout
	else:
		return null


func get_animation_time_modifier() -> float:
	if debug.is_on():
		return debug.get_animation_time_modifier()
	else:
		return 1.0
