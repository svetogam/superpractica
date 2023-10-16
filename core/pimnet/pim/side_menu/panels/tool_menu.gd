##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends WindowContent

signal tool_selected(tool_mode)

var _tool_to_text_map: Dictionary
var _button_group := ButtonGroup.new()
onready var _container := $"%ToolButtonContainer"


func setup(p_tool_to_text_map: Dictionary, tools:=[]) -> void:
	_tool_to_text_map = p_tool_to_text_map
	add_tools(tools)


func add_tools(tools: Array) -> void:
	for tool_mode in tools:
		add_tool(tool_mode)


func add_tool(tool_mode: String) -> void:
	var text = _tool_to_text_map[tool_mode]
	var button = ToolMenuButton.new(tool_mode, text, _button_group)
	button.connect("toggled", self, "_on_button_toggled")

	_container.add_child(button)


func _on_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		var tool_mode = _button_group.get_pressed_button().tool_mode
		emit_signal("tool_selected", tool_mode)


func get_current_tool() -> String:
	return _button_group.get_pressed_button().tool_mode


func set_tool(tool_mode: String) -> void:
	if tool_mode != "":
		var button = _get_button(tool_mode)
		button.pressed = true
	else:
		for button in _button_group.get_buttons():
			button.pressed = false


func enable_tool(tool_mode: String) -> void:
	var button = _get_button(tool_mode)
	button.disabled = false


func disable_tool(tool_mode: String) -> void:
	var button = _get_button(tool_mode)
	button.disabled = true


func disable_all() -> void:
	for button in _button_group.get_buttons():
		button.disabled = true


func enable_all() -> void:
	for button in _button_group.get_buttons():
		button.disabled = false


func enable_tools(tool_modes: Array) -> void:
	for tool_mode in tool_modes:
		enable_tool(tool_mode)


func disable_tools(tool_modes: Array) -> void:
	for tool_mode in tool_modes:
		disable_tool(tool_mode)


func _get_button(tool_mode: String) -> Button:
	for button in _button_group.get_buttons():
		if button.tool_mode == tool_mode:
			return button
	assert(false)
	return null


#Hack for the crooked container cartel
func _on_PanelContainer_resized() -> void:
	if _container != null:
		rect_min_size.y = _container.get_rect().size.y + 14


class ToolMenuButton:
	extends Button

	const MIN_BUTTON_SIZE := Vector2(30, 30)
	var tool_mode: String

	func _init(p_tool_mode: String, p_text: String, p_group: ButtonGroup) -> void:
		tool_mode = p_tool_mode
		text = p_text
		group = p_group
		mouse_filter = MOUSE_FILTER_PASS
		toggle_mode = true
		rect_min_size = MIN_BUTTON_SIZE
