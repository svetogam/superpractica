#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name GameProgressResource
extends Resource

var _completed_levels: Array = []


func set_current_level_completed() -> void:
	if Game.current_level != null:
		_completed_levels.append(Game.current_level.id)


func is_level_completed(level_id: String) -> bool:
	return _completed_levels.has(level_id)


func clear() -> void:
	_completed_levels.clear()


func get_current_level_title() -> String:
	if Game.current_level != null:
		var topic_title = Game.current_level.topic.title
		var level_title = Game.current_level.title
		return topic_title + " > " + level_title
	else:
		return "No Title"


func get_suggested_level_after_current() -> LevelResource:
	if Game.current_level != null:
		return Game.current_level.topic.get_suggested_level_after(Game.current_level.id)
	else:
		return null


func is_level_suggested_after_current() -> bool:
	return get_suggested_level_after_current() != null
