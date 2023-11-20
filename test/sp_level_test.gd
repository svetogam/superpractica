##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name SpLevelTest
extends SpIntegrationTest

const AWAIT_QUICK := 1.0
const AWAIT_LONG := 10.0
var level: Level
var pimnet: Pimnet
var verifier: Node


func after_each():
	super.after_each()
	if level != null:
		_remove_level()


func _load_level(group_name: String, level_name: String) -> void:
	var level_scene = Game.level_loader.get_level_scene(group_name, level_name)
	level = _load_scene(level_scene.resource_path)
	pimnet = level.pimnet
	verifier = level.verifier

	watch_signals(level)


func _remove_level() -> void:
	remove_child(level)
	level = null
	pimnet = null
	verifier = null


func _get_field_point_for(node: Node2D) -> Vector2:
	return pimnet.get_field_point_at_external_point(node.position)


func _get_await_time() -> float:
	return AWAIT_QUICK * Engine.time_scale
