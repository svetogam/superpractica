#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name LevelProgramState
extends State

var program: LevelProgram:
	set = _do_not_set,
	get = _get_program
var level: Level:
	set = _do_not_set,
	get = _get_level
var effect_layer: CanvasLayer:
	set = _do_not_set,
	get = _get_effect_layer
var verifier: Node:
	set = _do_not_set,
	get = _get_verifier
var screen_verifier: ScreenVerifier:
	set = _do_not_set,
	get = _get_screen_verifier
var pimnet: Pimnet:
	set = _do_not_set,
	get = _get_pimnet
var goal_panel: Control:
	set = _do_not_set,
	get = _get_goal_panel
var plan_panel: Control:
	set = _do_not_set,
	get = _get_plan_panel
var tool_panel: Control:
	set = _do_not_set,
	get = _get_tool_panel
var creation_panel: Control:
	set = _do_not_set,
	get = _get_creation_panel


func complete_task() -> void:
	program.complete_task()


func next() -> void:
	_transition("done")


func complete() -> void:
	complete_task()
	_transition("done")


func verify() -> void:
	level.reversion_control.clear_history()
	complete_task()
	_transition("verified")


func reject() -> void:
	_transition("rejected")


func _get_program() -> LevelProgram:
	assert(_target != null)
	return _target


func _get_level() -> Level:
	assert(program.level != null)
	return program.level


func _get_verifier() -> Node:
	assert(level.verifier != null)
	return level.verifier


func _get_screen_verifier() -> ScreenVerifier:
	assert(verifier.screen_verifier != null)
	return verifier.screen_verifier


func _get_effect_layer() -> CanvasLayer:
	assert(level.effect_layer != null)
	return level.effect_layer


func _get_pimnet() -> Pimnet:
	assert(program.pimnet != null)
	return program.pimnet


func _get_goal_panel() -> Control:
	assert(level.pimnet_screen_gui != null)
	assert(level.pimnet_screen_gui.goal_panel != null)
	return level.pimnet_screen_gui.goal_panel


func _get_plan_panel() -> Control:
	assert(level.pimnet_screen_gui != null)
	assert(level.pimnet_screen_gui.plan_panel != null)
	return level.pimnet_screen_gui.plan_panel


func _get_tool_panel() -> Control:
	assert(level.pimnet_screen_gui != null)
	assert(level.pimnet_screen_gui.tool_panel != null)
	return level.pimnet_screen_gui.tool_panel


func _get_creation_panel() -> Control:
	assert(level.pimnet_screen_gui != null)
	assert(level.pimnet_screen_gui.creation_panel != null)
	return level.pimnet_screen_gui.creation_panel


static func _do_not_set(_value: Variant) -> void:
	assert(false)
