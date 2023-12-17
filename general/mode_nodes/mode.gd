#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

class_name Mode
extends Node

signal started
signal stopped

@export var _target: Node:
	get = _get_target
@export var _auto_run := false
var _running := false


func _ready() -> void:
	if _auto_run:
		ready.connect(run)


func run() -> void:
	assert(not _running)
	_running = true

	_start()
	started.emit()


# Virtual
func _start() -> void:
	pass


func stop() -> void:
	if is_running():
		_running = false
		_end()
		stopped.emit()


# Virtual
func _end() -> void:
	pass


func is_running() -> bool:
	return _running


# Priority for target is: 1-mode-group's target, 2-inspector, 3-parent
func _get_target() -> Node:
	var mode_group := get_parent() as ModeGroup
	if mode_group != null:
		return mode_group._target
	else:
		if _target != null:
			return _target
		else:
			assert(get_parent() != null)
			return get_parent()
