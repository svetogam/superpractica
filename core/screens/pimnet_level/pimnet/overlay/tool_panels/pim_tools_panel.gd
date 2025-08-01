# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends BaseToolButtonPanel

signal tool_selected(toolset_name, tool_mode)

const ToolContainer := preload("tool_button_container.tscn")
@onready var _first_container: GridContainer = %ToolContainer1 as GridContainer


func add_toolset(data: FieldInterfaceData) -> void:
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
	_containers[toolset_name] = container
	container.interface_data = data
	show_toolset(toolset_name)

	# Connect buttons
	for button in container.get_tool_buttons():
		button.toggled.connect(_on_tool_button_toggled.bind(toolset_name))

	# Set up used buttons
	for tool_mode in data.get_tools():
		var tool_button = container.activate_tool_button(tool_mode)
		tool_button.icon = data.get_tool_icon(tool_mode)
		tool_button.tooltip_text = data.get_tool_text(tool_mode)


func on_field_tool_changed(tool_mode: String, toolset_name: String) -> void:
	_containers[toolset_name].current_tool = tool_mode


func deactivate(toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	_containers[toolset_name].current_tool = Field.NO_TOOL


func force_selection(value := true) -> void:
	for container in _containers.values():
		container.tool_button_group.allow_unpress = not value


func _on_tool_button_toggled(_button_pressed: bool, toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	var tool_mode = _containers[toolset_name].current_tool
	tool_selected.emit(toolset_name, tool_mode)
