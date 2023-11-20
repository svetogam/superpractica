##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Node

var debug := GameDebug.new()
@onready var level_loader := $LevelLoader as LevelLoader


#####################################################################
# Screen Switching
#####################################################################

enum Screens {
	LEVEL_SELECT,
}
const SCREEN_MAP := {
	Screens.LEVEL_SELECT: "res://core/level_select_menu.tscn",
}


func enter_screen(screen_id: int) -> void:
	get_tree().change_scene_to_file(SCREEN_MAP[screen_id])


func enter_level_select() -> void:
	enter_screen(Screens.LEVEL_SELECT)


#####################################################################
# Speed and Timing
#####################################################################

func call_after(object: Object, method_name: String, time_delay: float, args:=[]) -> void:
	if debug.is_on() and debug.should_skip_delays() or time_delay <= 0:
		object.callv(method_name, args)
	else:
		var timer = get_tree().create_timer(time_delay)
		timer.timeout.connect(Callable(object, method_name).bindv(args))


func wait_for(time: float):
	if debug.is_on():
		return debug.debug_wait_for(time)
	elif time > 0:
		var wait_timer = get_tree().create_timer(time)
		return wait_timer.timeout
	else:
		return null


func get_animation_time_modifier() -> float:
	if debug.is_on():
		return debug.get_animation_time_modifier()
	else:
		return 1.0
