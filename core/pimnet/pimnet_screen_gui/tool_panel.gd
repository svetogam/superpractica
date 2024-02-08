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

signal tool_selected(tool_mode)

const MAX_TOOL_BUTTONS: int = 15

var current_tool: int:
	set = set_tool,
	get = _get_active_tool
var _tool_modes_to_buttons_dict: Dictionary
@onready var _tool_buttons: Array = [
	%ToolButton1, %ToolButton2, %ToolButton3, %ToolButton4, %ToolButton5,
	%ToolButton6, %ToolButton7, %ToolButton8, %ToolButton9, %ToolButton10,
	%ToolButton11, %ToolButton12, %ToolButton13, %ToolButton14, %ToolButton15,
]
@onready var _button_group: ButtonGroup = _tool_buttons[0].button_group


func _ready() -> void:
	for button in _tool_buttons:
		button.toggled.connect(_on_tool_button_toggled)


func setup(data: PimInterfaceData) -> void:
	var i: int = 0
	for tool_mode in data.get_tools():
		_tool_buttons[i].visible = true
		_tool_buttons[i].text = data.get_tool_text(tool_mode)
		_tool_buttons[i].tooltip_text = data.get_tool_text(tool_mode)
		_tool_modes_to_buttons_dict[tool_mode] = _tool_buttons[i]
		i += 1

	for j in range(i, MAX_TOOL_BUTTONS):
		_tool_buttons[j].visible = false


func include(tool_mode: int) -> void:
	assert(_tool_modes_to_buttons_dict.has(tool_mode))
	var button = _tool_modes_to_buttons_dict[tool_mode]
	button.visible = true


func exclude(tool_mode: int) -> void:
	assert(_tool_modes_to_buttons_dict.has(tool_mode))
	var button = _tool_modes_to_buttons_dict[tool_mode]
	if button.button_pressed:
		button.button_pressed = false
	button.visible = false


func include_all() -> void:
	for tool_mode in _tool_modes_to_buttons_dict.keys():
		include(tool_mode)


func exclude_all() -> void:
	for tool_mode in _tool_modes_to_buttons_dict.keys():
		exclude(tool_mode)


func enable(tool_mode: int) -> void:
	assert(_tool_modes_to_buttons_dict.has(tool_mode))
	var button = _tool_modes_to_buttons_dict[tool_mode]
	button.disabled = false


func disable(tool_mode: int) -> void:
	assert(_tool_modes_to_buttons_dict.has(tool_mode))
	var button = _tool_modes_to_buttons_dict[tool_mode]
	button.disabled = true


func enable_all() -> void:
	for tool_mode in _tool_modes_to_buttons_dict.keys():
		enable(tool_mode)


func disable_all() -> void:
	for tool_mode in _tool_modes_to_buttons_dict.keys():
		disable(tool_mode)


func set_tool(tool_mode: int) -> void:
	if tool_mode != GameGlobals.NO_TOOL:
		assert(_tool_modes_to_buttons_dict.has(tool_mode))
		var button = _tool_modes_to_buttons_dict[tool_mode]
		button.button_pressed = true
	else:
		for button in _tool_modes_to_buttons_dict.values():
			button.button_pressed = false

	current_tool = tool_mode


func deactivate() -> void:
	set_tool(GameGlobals.NO_TOOL)


func force_selection(value := true) -> void:
	_button_group.allow_unpress = not value


func _get_active_tool() -> int:
	return current_tool


func _on_tool_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		var button = _button_group.get_pressed_button()
		var tool_mode = _get_tool_mode_by_button_name(button.name)
		tool_selected.emit(tool_mode)
	elif _button_group.get_pressed_button() == null:
		tool_selected.emit(GameGlobals.NO_TOOL)


func _get_tool_mode_by_button_name(button_name: String) -> int:
	for tool_mode in _tool_modes_to_buttons_dict.keys():
		var button = _tool_modes_to_buttons_dict[tool_mode]
		if button.name == button_name:
			return tool_mode
	assert(false)
	return GameGlobals.NO_TOOL
