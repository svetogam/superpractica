# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal request_enter_main_menu
signal request_load_level_select
signal request_enter_level_select
signal request_load_level(level_data)
signal request_unload_level(level_data)
signal request_enter_level(level_data)
signal request_exit_game

enum SuggestiveSignals {
	NONE,
	AFFIRM, # Correct after action
	REJECT, # Incorrect after action
	GUIDE, # Correct before action
	WARN, # Incorrect before action
}

const SERVICE_LEVEL_DATA := "level_data"
const SERVICE_PIMNET := "pimnet"
const SERVICE_FIELD := "field"
const SERVICE_ROOT_EFFECT_LAYER := "effect_layer"
const SERVICE_VERIFIER := "verifier"
const SERVICE_REVERTER := "reverter"
const SERVICE_PIMNET_LEVEL_VIEWPORT := "pimnet_level_viewport"
const SERVICE_THUMBNAIL_CAMERA := "thumbnail_camera"

const AGENT_FIELD := "fields"
const AGENT_MEMO_SLOT := "memo_slots"
const AGENT_VERIFICATION := "verifications"

const NO_OBJECT: int = -1
const NO_TOOL: int = -1

const WEBSITE_URL := "https://superpractica.org"
const REPO_URL := "https://codeberg.org/superpractica/superpractica"

var root_topic: TopicResource
var progress_data := GameProgressResource.new()
var debug := GameDebug.new()
var version: String:
	get:
		return ProjectSettings.get("application/config/version")
var version_tag: String:
	get:
		return "v" + version


#====================================================================
# Timing
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


func continue_as_coroutine() -> void:
	await get_tree().process_frame


#====================================================================
# Other
#====================================================================

# This doesn't actually do anything, but it's nice to have as a wrapper
func get_screen_rect() -> Rect2:
	if debug.is_on() and not RenderingServer.render_loop_enabled:
		return debug.fallback_screen_rect
	else:
		return get_viewport().get_visible_rect()
