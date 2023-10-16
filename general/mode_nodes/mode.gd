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

export(NodePath) var _target_path: NodePath
export(bool) var _auto_run := false
var _target: Node
var _running := false


func _enter_tree() -> void:
	var parent = get_parent()
	if parent is ModeGroup:
		_target = parent._target
	else:
		if not _target_path.is_empty():
			_target = get_node(_target_path)
		else:
			_target = get_parent()
	assert(_target != null)


func _ready() -> void:
	if _auto_run:
		connect("ready", self, "run")


func run() -> void:
	assert(not _running)
	_running = true
	_pre_start()

	_start()
	emit_signal("started")


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
		emit_signal("stopped")


#Virtual
func _end() -> void:
	pass


func is_running() -> bool:
	return _running
