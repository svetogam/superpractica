# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name FieldInterfaceData
extends Resource

var field_type := ""
var object_data: Dictionary = {}
var tool_data: Dictionary = {}


func get_draggable_objects() -> Array:
	var draggable_object_keys: Array = []
	for key in object_data.keys():
		if object_data[key].is_draggable():
			draggable_object_keys.append(key)
	return draggable_object_keys


func get_object_text(object: int) -> String:
	return object_data[object].name_text


func get_object_icon(object: int) -> Texture2D:
	return object_data[object].icon


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


func get_tool_icon(tool: int) -> Texture2D:
	return tool_data[tool].icon
