#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name LevelLoader
extends Node

var _level_groups: Array = []
var _most_recent_level_group := ""
var _most_recent_level := ""


func add_level_group(level_group: LevelGroupResource, index: int = -1) -> void:
	if index == -1:
		_level_groups.append(level_group)
	else:
		assert(index <= _level_groups.size())
		_level_groups.insert(index, level_group)


func enter_level(level_group_name: String, level_name: String) -> void:
	var level_group := _get_level_group(level_group_name)
	var scene := level_group.get_level_scene(level_name)
	_most_recent_level_group = level_group_name
	_most_recent_level = level_name
	get_tree().change_scene_to_packed(scene)


func get_level_groups() -> Array:
	return _level_groups


func get_level_scene(level_group_name: String, level_name: String) -> PackedScene:
	for group in get_level_groups():
		if group.name == level_group_name and group.has(level_name):
			return group.get_level_scene(level_name)
	return null


func _get_level_group(level_group_name: String) -> LevelGroupResource:
	for level_group in _level_groups:
		if level_group.name == level_group_name:
			return level_group
	return null


func get_most_recent_level() -> String:
	return _most_recent_level


func get_most_recent_level_group() -> String:
	return _most_recent_level_group
