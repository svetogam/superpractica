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

const SERVICE_PIMNET := "pimnet"
const SERVICE_FIELD := "field"
const SERVICE_ROOT_EFFECT_LAYER := "effect_layer"
const SERVICE_VERIFIER := "verifier"
const SERVICE_REVERTER := "reverter"

const NO_OBJECT: int = -1
const NO_TOOL: int = -1

const RELEASE_TAG := "v0.7.0"
const WEBSITE_URL := "https://superpractica.org"
const SOURCE_URL := "https://codeberg.org/superpractica/superpractica"

const COLOR_HIGHLIGHT := Color(1.0, 1.0, 0.5)
const COLOR_REJECTION := Color(1.0, 0.0, 0.0)
const COLOR_AFFIRMATION := Color(0.6, 1.0, 0.6)
const COLOR_GUIDE := Color(0.5, 0.5, 1.0)

var debug := GameDebug.new()


#====================================================================
# Content State
#====================================================================
#region

var root_topic: TopicResource
var progress_data := GameProgressResource.new()
var current_level: LevelResource = null


func set_current_level_completed() -> void:
	if current_level != null:
		progress_data.completed_levels.append(current_level.id)


func get_current_level_title() -> String:
	if current_level != null:
		var topic_title = current_level.topic.title
		var level_title = current_level.title
		return topic_title + " > " + level_title
	else:
		return "No Title"


func get_suggested_level_after_current() -> LevelResource:
	if current_level != null:
		return current_level.topic.get_suggested_level_after(current_level.id)
	else:
		return null


func is_level_suggested_after_current() -> bool:
	return get_suggested_level_after_current() != null


#endregion
#====================================================================
# Timing
#====================================================================
#region

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


#endregion
#====================================================================
# Other
#====================================================================
#region

# This doesn't actually do anything, but it's nice to have as a wrapper
func get_screen_rect() -> Rect2:
	if debug.is_on() and not RenderingServer.render_loop_enabled:
		return debug.fallback_screen_rect
	else:
		return get_viewport().get_visible_rect()


#endregion
