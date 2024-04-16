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
var creation_data: Dictionary = {}


func get_tools() -> Array:
	return tool_data.keys()


func get_tool_name(tool: int) -> String:
	return tool_data[tool].name


func get_tool_by_name(tool_name: String) -> int:
	for tool in tool_data:
		if tool_data[tool].name == tool_name:
			return tool
	return GameGlobals.NO_TOOL


func get_object_modes(tool: int, object: int) -> Array:
	if tool_data.has(tool) and tool_data[tool].object_modes.has(object):
		return tool_data[tool].object_modes[object]
	else:
		return []


func get_tool_text(tool: int) -> String:
	return tool_data[tool].text


func get_creatable_objects() -> Array:
	return creation_data.keys()


func make_creatable_object_graphic(object: int) -> Node2D:
	return creation_data[object].graphic.new()


func get_creatable_object_text(object: int) -> String:
	return creation_data[object].text
