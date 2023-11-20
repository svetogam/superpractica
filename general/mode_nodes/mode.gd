##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name Mode
extends Node

signal started
signal stopped

@export var _target: Node
@export var _auto_run := false
var _running := false


#Priority for target is: 1-mode-group, 2-inspector, 3-parent
func _enter_tree() -> void:
	var mode_group := get_parent() as ModeGroup
	if mode_group != null:
		_target = mode_group._target
	elif _target == null:
		_target = get_parent()
	assert(_target != null)


func _ready() -> void:
	if _auto_run:
		ready.connect(run)


func run() -> void:
	assert(not _running)
	_running = true
	_pre_start()

	_start()
	started.emit()


#Virtual
func _pre_start() -> void:
	pass


#Virtual
func _start() -> void:
	pass


func stop() -> void:
	if is_running():
		_running = false
		_end()
		stopped.emit()


#Virtual
func _end() -> void:
	pass


func is_running() -> bool:
	return _running
