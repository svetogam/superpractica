#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PanelContainer

signal tool_selected(toolset_name, tool_mode)

const MAX_TOOL_BUTTONS: int = 15
var _container_modes_to_buttons_dict: Dictionary
var _toolset_to_current_tool_dict: Dictionary
var _toolsets_to_containers_dict: Dictionary
@onready var _container_prototype: GridContainer = %ToolContainer as GridContainer


func setup(data: PimInterfaceData) -> void:
	# Ignore repeated setups
	if _toolsets_to_containers_dict.has(data.field_type):
		return

	# Hide other containers
	_container_prototype.visible = false
	for container in _get_container_list():
		container.visible = false

	# Add new container
	var container := _container_prototype.duplicate()
	_container_prototype.add_sibling(container)
	container.visible = true
	_toolsets_to_containers_dict[data.field_type] = container

	# Connect all buttons
	for button in _get_tool_buttons(container):
		button.toggled.connect(_on_tool_button_toggled.bind(button, data.field_type))

	# Set up used buttons
	var tool_buttons = _get_tool_buttons(container)
	var tool_modes_to_buttons_dict := {}
	var button_group = ButtonGroup.new()
	button_group.allow_unpress = true
	var i: int = 0
	for tool_mode in data.get_tools():
		tool_buttons[i].visible = true
		tool_buttons[i].text = data.get_tool_text(tool_mode)
		tool_buttons[i].tooltip_text = data.get_tool_text(tool_mode)
		tool_buttons[i].button_group = button_group
		tool_modes_to_buttons_dict[tool_mode] = tool_buttons[i]
		i += 1
	_container_modes_to_buttons_dict[data.field_type] = tool_modes_to_buttons_dict

	# Hide unused buttons
	for j in range(i, MAX_TOOL_BUTTONS):
		tool_buttons[j].visible = false


func show_toolset(toolset_name: String) -> void:
	for container in _get_container_list():
		container.visible = false
	_toolsets_to_containers_dict[toolset_name].visible = true


func include(toolset_name: String, tool_mode: int) -> void:
	var button = _get_tool_button(toolset_name, tool_mode)
	button.visible = true


func exclude(toolset_name: String, tool_mode: int) -> void:
	var button = _get_tool_button(toolset_name, tool_mode)
	if button.button_pressed:
		button.button_pressed = false
	button.visible = false


func include_all(toolset_name: String) -> void:
	for tool_mode in _get_tool_modes(toolset_name):
		include(toolset_name, tool_mode)


func exclude_all(toolset_name: String) -> void:
	for tool_mode in _get_tool_modes(toolset_name):
		exclude(toolset_name, tool_mode)


func enable(toolset_name: String, tool_mode: int) -> void:
	assert(_container_modes_to_buttons_dict[toolset_name].has(tool_mode))
	var button = _get_tool_button(toolset_name, tool_mode)
	button.disabled = false


func disable(toolset_name: String, tool_mode: int) -> void:
	assert(_container_modes_to_buttons_dict[toolset_name].has(tool_mode))
	var button = _get_tool_button(toolset_name, tool_mode)
	button.disabled = true


func enable_all(toolset_name: String) -> void:
	for tool_mode in _get_tool_modes(toolset_name):
		enable(toolset_name, tool_mode)


func disable_all(toolset_name: String) -> void:
	for tool_mode in _get_tool_modes(toolset_name):
		disable(toolset_name, tool_mode)


func on_field_tool_changed(tool_mode: int, field_type: String) -> void:
	set_tool(field_type, tool_mode)


func set_tool(toolset_name: String, tool_mode: int) -> void:
	if tool_mode != GameGlobals.NO_TOOL:
		assert(_container_modes_to_buttons_dict[toolset_name].has(tool_mode))
		var button = _get_tool_button(toolset_name, tool_mode)
		button.button_pressed = true
	else:
		for button in _container_modes_to_buttons_dict[toolset_name].values():
			button.button_pressed = false

	_toolset_to_current_tool_dict[toolset_name] = tool_mode


func deactivate(toolset_name: String) -> void:
	set_tool(toolset_name, GameGlobals.NO_TOOL)


func force_selection(value := true) -> void:
	for container in _get_container_list():
		_get_button_group(container).allow_unpress = not value


func _on_tool_button_toggled(button_pressed: bool, button: Button, toolset_name: String
) -> void:
	var pressed_button = button.button_group.get_pressed_button()
	if button_pressed:
		var tool_mode = _get_tool_mode_by_button_name(toolset_name, pressed_button.name)
		tool_selected.emit(toolset_name, tool_mode)
	elif pressed_button == null:
		tool_selected.emit(toolset_name, GameGlobals.NO_TOOL)


func _get_tool_mode_by_button_name(toolset_name: String, button_name: String) -> int:
	for tool_mode in _get_tool_modes(toolset_name):
		var button = _get_tool_button(toolset_name, tool_mode)
		if button.name == button_name:
			return tool_mode
	assert(false)
	return GameGlobals.NO_TOOL


func _get_active_tool(toolset_name: String) -> int:
	return _toolset_to_current_tool_dict[toolset_name]


func _get_tool_buttons(container: GridContainer) -> Array:
	var buttons: Array = []
	for child in container.get_children():
		if child is Button:
			buttons.append(child)
	return buttons


func _get_tool_button(toolset_name: String, tool_mode: int) -> Button:
	assert(_container_modes_to_buttons_dict.has(toolset_name))
	assert(_container_modes_to_buttons_dict[toolset_name].has(tool_mode))
	return _container_modes_to_buttons_dict[toolset_name][tool_mode]


func _get_tool_modes(toolset_name: String) -> Array:
	assert(_container_modes_to_buttons_dict.has(toolset_name))
	return _container_modes_to_buttons_dict[toolset_name].keys()


func _get_container_list() -> Array:
	return _toolsets_to_containers_dict.values()


func _get_button_group(container: GridContainer) -> ButtonGroup:
	return _get_tool_buttons(container)[0].button_group
