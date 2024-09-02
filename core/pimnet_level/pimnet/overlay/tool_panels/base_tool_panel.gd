#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name BasePimnetToolPanel
extends PanelContainer

var _containers: Dictionary # {toolset_name_1: container_object_1, ...}


# Virtual
func add_toolset(_data: PimInterfaceData) -> void:
	pass


# Virtual
func _new_container() -> GridContainer:
	return null


func show_toolset(toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	for container in _containers.values():
		container.visible = false
	_containers[toolset_name].visible = true


func include(toolset_name: String, tool_mode: int) -> void:
	assert(_containers.has(toolset_name))
	var button = _containers[toolset_name].get_tool_button(tool_mode)
	button.visible = true


func exclude(toolset_name: String, tool_mode: int) -> void:
	assert(_containers.has(toolset_name))
	var button = _containers[toolset_name].get_tool_button(tool_mode)
	if button.button_pressed:
		button.button_pressed = false
	button.visible = false


func include_all(toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	for tool_mode in _containers[toolset_name].get_tool_modes():
		include(toolset_name, tool_mode)


func exclude_all(toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	for tool_mode in _containers[toolset_name].get_tool_modes():
		exclude(toolset_name, tool_mode)


func enable(toolset_name: String, tool_mode: int) -> void:
	assert(_containers.has(toolset_name))
	var button = _containers[toolset_name].get_tool_button(tool_mode)
	button.disabled = false


func disable(toolset_name: String, tool_mode: int) -> void:
	assert(_containers.has(toolset_name))
	var button = _containers[toolset_name].get_tool_button(tool_mode)
	button.disabled = true


func enable_all(toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	for tool_mode in _containers[toolset_name].get_tool_modes():
		enable(toolset_name, tool_mode)


func disable_all(toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	for tool_mode in _containers[toolset_name].get_tool_modes():
		disable(toolset_name, tool_mode)