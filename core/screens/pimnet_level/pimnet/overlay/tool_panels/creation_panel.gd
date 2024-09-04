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

signal tool_dragged(toolset_name, tool_mode, drag_graphic)

const ToolContainer := preload("creatables_container.tscn")
@onready var _first_container: GridContainer = %CreatablesContainer1 as GridContainer


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
		container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_containers[toolset_name] = container
	container.interface_data = data
	show_toolset(toolset_name)

	# Connect buttons
	for button in container.get_tool_buttons():
		button.button_down.connect(_on_tool_button_down.bind(toolset_name))

	# Set up used buttons
	for object_type in data.get_draggable_objects():
		var tool_button = container.activate_tool_button(object_type)
		tool_button.text = ""
		tool_button.tooltip_text = data.get_draggable_object_text(object_type)

		# Set icon or use sprite as fallback if no icon is found
		var icon = data.get_draggable_object_icon(object_type)
		if icon != null:
			tool_button.icon = icon
		else:
			var sprite = data.new_draggable_object_sprite(object_type)
			tool_button.add_child(sprite)
			sprite.position = tool_button.get_rect().get_center()


func _on_tool_button_down(toolset_name: String) -> void:
	assert(_containers.has(toolset_name))
	var container = _containers[toolset_name]
	var tool_mode = container.current_tool
	tool_dragged.emit(toolset_name, tool_mode,
			container.interface_data.new_draggable_object_sprite(tool_mode))
