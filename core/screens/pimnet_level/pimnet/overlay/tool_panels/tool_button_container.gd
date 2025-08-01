# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends GridContainer

const NULL_SELECTION: String = Field.NO_TOOL
var interface_data: FieldInterfaceData
var current_tool: String:
	set = set_current_tool,
	get = get_current_tool
var tool_button_group := ButtonGroup.new()
var _tool_modes_to_buttons_dict := {}


func _ready() -> void:
	tool_button_group.allow_unpress = true

	for tool_button in get_tool_buttons():
		tool_button.visible = false


func activate_tool_button(tool_mode: String) -> BaseButton:
	var next_index := _tool_modes_to_buttons_dict.size()
	if next_index > get_tool_buttons().size():
		assert(false)

	var button = get_tool_buttons()[next_index]
	button.visible = true
	button.button_group = tool_button_group
	_tool_modes_to_buttons_dict[tool_mode] = button
	return button


func set_current_tool(tool_mode: String) -> void:
	if tool_mode != NULL_SELECTION:
		var button = get_tool_button(tool_mode)
		button.button_pressed = true
	else:
		for button in get_tool_buttons():
			button.button_pressed = false

	current_tool = tool_mode


func get_current_tool() -> String:
	var pressed_button = tool_button_group.get_pressed_button()
	if pressed_button != null:
		for tool_mode in get_tool_modes():
			var button = get_tool_button(tool_mode)
			if button.get_instance_id() == pressed_button.get_instance_id():
				return tool_mode
	else:
		return NULL_SELECTION
	assert(false)
	return NULL_SELECTION


func get_tool_buttons() -> Array:
	var buttons: Array = []
	for child in get_children():
		if child is Button:
			buttons.append(child)
	return buttons


func get_tool_button(tool_mode: String) -> Button:
	assert(_tool_modes_to_buttons_dict.has(tool_mode))
	return _tool_modes_to_buttons_dict[tool_mode]


func get_tool_modes() -> Array:
	return _tool_modes_to_buttons_dict.keys()
