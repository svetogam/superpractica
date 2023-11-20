##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name LevelGroupResource
extends Resource

@export var name: String
@export var _name_text: String
@export var _levels: Array[LevelResource]


func get_name_text() -> String:
	return _name_text


func get_level_names() -> Array:
	var level_names = []
	for level in _levels:
		level_names.append(level.name)
	return level_names


func get_level_name_text(level_name: String):
	var level = _get_level(level_name)
	return level.get_name_text()


func get_level_scene(level_name: String):
	var level = _get_level(level_name)
	return level.get_scene()


func has(level_name: String) -> bool:
	return _get_level(level_name) != null


func _get_level(level_name: String) -> LevelResource:
	for level in _levels:
		if level.name == level_name:
			return level
	return null
