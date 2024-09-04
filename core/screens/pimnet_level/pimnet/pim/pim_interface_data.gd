#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name PimInterfaceData
extends Resource

var field_type := ""
var tool_data: Dictionary = {}
var draggable_object_data: Dictionary = {}


func get_tools() -> Array:
	return tool_data.keys()


func get_tool_name(tool: int) -> String:
	return tool_data[tool].name


func get_tool_by_name(tool_name: String) -> int:
	for tool in tool_data:
		if tool_data[tool].name == tool_name:
			return tool
	return Game.NO_TOOL


func get_object_modes(tool: int, object: int) -> Array:
	if tool_data.has(tool) and tool_data[tool].object_modes.has(object):
		return tool_data[tool].object_modes[object]
	else:
		return []


func get_tool_text(tool: int) -> String:
	return tool_data[tool].text


func get_draggable_objects() -> Array:
	return draggable_object_data.keys()


func get_draggable_object_text(object: int) -> String:
	return draggable_object_data[object].text


func new_draggable_object_sprite(object: int) -> Node2D:
	var sprite = draggable_object_data[object].sprite
	if sprite is GDScript:
		return sprite.new()
	elif sprite is PackedScene:
		return sprite.instantiate()
	assert(false)
	return null


func get_draggable_object_icon(object: int) -> Texture2D:
	if draggable_object_data[object].has("icon"):
		return draggable_object_data[object].icon
	return null
