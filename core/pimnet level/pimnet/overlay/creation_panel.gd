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

signal object_grabbed(object_type, interface_data)

const MAX_BUTTONS: int = 6
var _toolset_dict: Dictionary
@onready var _container_prototype: GridContainer = %CreatablesContainer as GridContainer


func setup(data: PimInterfaceData) -> void:
	# Ignore repeated setups
	if _toolset_dict.has(data.field_type):
		return

	# Initialize data
	_toolset_dict[data.field_type] = {}
	_toolset_dict[data.field_type]["data"] = data

	# Add new container
	var new_container := _container_prototype.duplicate()
	_container_prototype.add_sibling(new_container)
	_toolset_dict[data.field_type]["container"] = new_container

	# Only show new container
	_container_prototype.visible = false
	for container in _get_container_list():
		container.visible = false
	new_container.visible = true

	# Connect all buttons
	var index: int = 0
	for button in _get_buttons(new_container):
		button.button_down.connect(_on_button_down.bind(index, data.field_type))
		index += 1

	# Set up used buttons and object types in order
	var buttons = _get_buttons(new_container)
	var toolset_objects: Array = []
	var i: int = 0
	for object_type in data.get_creatable_objects():
		buttons[i].visible = true
		buttons[i].text = ""
		buttons[i].tooltip_text = data.get_creatable_object_text(object_type)
		var graphic := data.make_creatable_object_graphic(object_type)
		buttons[i].add_child(graphic)
		graphic.position = buttons[i].get_rect().get_center()
		toolset_objects.append(object_type)
		i += 1
	_toolset_dict[data.field_type]["objects"] = toolset_objects

	# Hide unused buttons
	for j in range(i, MAX_BUTTONS):
		buttons[j].visible = false


func include(toolset_name: String, object_type: int) -> void:
	var container = _toolset_dict[toolset_name]["container"]
	var index := _get_button_index(toolset_name, object_type)
	_get_buttons(container)[index].visible = true


func exclude(toolset_name: String, object_type: int) -> void:
	var container = _toolset_dict[toolset_name]["container"]
	var index := _get_button_index(toolset_name, object_type)
	_get_buttons(container)[index].visible = false


func include_all(toolset_name: String) -> void:
	for object_type in _get_object_types(toolset_name):
		include(toolset_name, object_type)


func exclude_all(toolset_name: String) -> void:
	for object_type in _get_object_types(toolset_name):
		exclude(toolset_name, object_type)


func show_toolset(toolset_name: String) -> void:
	for container in _get_container_list():
		container.visible = false
	_toolset_dict[toolset_name]["container"].visible = true


func _on_button_down(button_index: int, toolset_name: String) -> void:
	var object_type = _get_object_types(toolset_name)[button_index]
	object_grabbed.emit(object_type, _toolset_dict[toolset_name]["data"])


func _get_button_index(toolset_name: String, object_type: int) -> int:
	var found = _get_object_types(toolset_name).find(object_type)
	assert(found != -1)
	return found


func _get_object_types(toolset_name: String) -> Array:
	assert(_toolset_dict.has(toolset_name))
	assert(_toolset_dict[toolset_name].has("objects"))
	return _toolset_dict[toolset_name]["objects"]


func _get_buttons(container: GridContainer) -> Array:
	var buttons: Array = []
	for child in container.get_children():
		if child is Button:
			buttons.append(child)
	return buttons


func _get_container_list() -> Array:
	var containers: Array = []
	for toolset in _toolset_dict.keys():
		containers.append(_toolset_dict[toolset]["container"])
	return containers
