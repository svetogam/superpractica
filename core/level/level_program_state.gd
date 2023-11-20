##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name LevelProgramState
extends State

var program: LevelProgram
var level: Level
var effect_layer: CanvasLayer
var verifier: Node
var screen_verifier: ScreenVerifier
var pimnet: Pimnet
var event_menu: Control
var event_control: Node


func _on_setup() -> void:
	_setup_shortcuts()


func _setup_shortcuts() -> void:
	program = _target
	assert(program != null)
	level = program.level
	assert(level != null)
	verifier = level.verifier
	assert(verifier != null)
	screen_verifier = verifier.screen_verifications
	assert(screen_verifier != null)
	effect_layer = level.effect_layer
	assert(effect_layer != null)
	pimnet = program.pimnet
	assert(pimnet != null)
	event_control = level.event_control
	assert(event_control != null)


func complete_task() -> void:
	program.complete_task()


func next() -> void:
	_transition("done")


func complete() -> void:
	complete_task()
	_transition("done")


func verify() -> void:
	level.metanavig_control.clear_history()
	complete_task()
	_transition("verified")


func reject() -> void:
	_transition("rejected")
