#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends BasePimnetToolPanel

signal tool_selected(toolset_name, tool_mode)

const ToolContainer := preload("tool_container.tscn")
@onready var _first_container: GridContainer = %ToolContainer1 as GridContainer


func add_toolset(data: PimInterfaceData) -> void:
	var toolset_name := data.field_type

	# Ignore repeats
	if _containers.has(toolset_name):
		return

	# Add new container
	var container
	if _containers.is_empty():
		container = _first_container
		container.show()
	else:
		container = ToolContainer.instantiate()
		_first_container.add_sibling(container)
		container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_containers[toolset_name] = container
	container.interface_data = data
	show_toolset(toolset_name)

	# Connect buttons
	var tool_buttons = container.get_tool_buttons()
	for button in tool_buttons:
		button.toggled.connect(_on_tool_button_toggled.bind(toolset_name))

	# Set up used buttons
	for tool_mode in data.get_tools():
		var tool_button = container.activate_tool_button(tool_mode)
		tool_button.text = data.get_tool_text(tool_mode)
		tool_button.tooltip_text = data.get_tool_text(tool_mode)


func on_field_tool_changed(tool_mode: int, toolset_name: String) -> void:
	_containers[toolset_name].current_tool = tool_mode


func deactivate(toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	_containers[toolset_name].current_tool = Game.NO_TOOL


func force_selection(value := true) -> void:
	for container in _containers.values():
		container.tool_button_group.allow_unpress = not value


func _on_tool_button_toggled(_button_pressed: bool, toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	var tool_mode = _containers[toolset_name].current_tool
	tool_selected.emit(toolset_name, tool_mode)
