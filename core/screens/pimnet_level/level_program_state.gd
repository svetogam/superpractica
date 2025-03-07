# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LevelProgramState
extends State

var program: LevelProgram:
	get:
		assert(_target != null)
		return _target
var level: Level:
	get:
		assert(program.level != null)
		return program.level
var effect_layer: CanvasLayer:
	get:
		assert(level.effect_layer != null)
		return level.effect_layer
var verifier: Node:
	get:
		assert(level.verifier != null)
		return level.verifier
var pimnet: Pimnet:
	get:
		assert(program.pimnet != null)
		return program.pimnet
var overlay: PimnetOverlay:
	get:
		assert(level.pimnet.overlay != null)
		return program.pimnet.overlay
var goal_panel: Control:
	get:
		assert(level.pimnet.overlay.goal_panel != null)
		return level.pimnet.overlay.goal_panel
var plan_panel: Control:
	get:
		assert(level.pimnet.overlay.plan_panel != null)
		return level.pimnet.overlay.plan_panel


func complete_task() -> void:
	program.complete_task()


func next() -> void:
	_transition("done")


func complete() -> void:
	complete_task()
	_transition("done")


func verify() -> void:
	level.reverter.history.clear()
	complete_task()
	_transition("verified")


func reject() -> void:
	_transition("rejected")
