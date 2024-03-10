#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name SpLevelTest
extends SpIntegrationTest

var level: Level
var pimnet: Pimnet
var verifier: Node
var program: LevelProgram


func before_each():
	Game.current_level = null
	super()


func after_each():
	super()
	if level != null:
		_remove_level()


func _load_level(path: String) -> void:
	level = _load_scene(path)
	pimnet = level.pimnet
	verifier = level.verifier
	program = level._program

	watch_signals(level)


func _remove_level() -> void:
	level.free()
	level = null
	pimnet = null
	verifier = null
	program = null


func _get_field_point_for(node: Node2D) -> Vector2:
	return pimnet.get_field_point_at_external_point(node.position)
