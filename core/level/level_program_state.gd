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
var event_control: Node:
	set = _do_not_set,
	get = _get_event_control


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


func _get_event_control() -> Node:
	assert(level.event_control != null)
	return level.event_control


static func _do_not_set(_value: Variant) -> void:
	assert(false)
