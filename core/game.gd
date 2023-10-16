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
onready var level_loader := $LevelLoader


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
	get_tree().change_scene(SCREEN_MAP[screen_id])


func enter_level_select() -> void:
	enter_screen(Screens.LEVEL_SELECT)


#####################################################################
# Speed and Timing
#####################################################################

const DONE = "completed"


func call_after(object: Object, method_name: String, time_delay: float, args:=[]) -> void:
	if debug.is_on() and debug.should_skip_delays():
		object.callv(method_name, args)
	else:
		var timer = Game.wait_for(time_delay)
		timer.connect(Game.DONE, object, method_name, args)


func wait_for(time: float) -> Timer:
	if debug.is_on():
		return debug.create_wait_timer(time)
	else:
		return Utils.create_wait_timer("timeout", time)


func get_animation_time_modifier() -> float:
	if debug.is_on():
		return debug.get_animation_time_modifier()
	else:
		return 1.0
