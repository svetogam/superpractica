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

signal object_grabbed(object_type)

const MAX_BUTTONS: int = 6

var _button_index_to_object_type_dict: Dictionary
@onready var _buttons: Array = [
	%CreateButton1, %CreateButton2, %CreateButton3, %CreateButton4, %CreateButton5,
	%CreateButton6,
]


func _ready() -> void:
	var index: int = 0
	for button in _buttons:
		button.button_down.connect(_on_button_down.bind(index))
		index += 1


func setup(data: PimInterfaceData) -> void:
	var i: int = 0
	for object_type in data.get_creatable_objects():
		_buttons[i].visible = true
		_buttons[i].text = ""
		_buttons[i].tooltip_text = data.get_creatable_object_text(object_type)
		var graphic := data.make_creatable_object_graphic(object_type)
		_buttons[i].add_child(graphic)
		graphic.position = _buttons[i].get_rect().get_center()
		_button_index_to_object_type_dict[i] = object_type
		i += 1

	for j in range(i, MAX_BUTTONS):
		_buttons[j].visible = false


func include(object_type: int) -> void:
	assert(_button_index_to_object_type_dict.values().has(object_type))
	var index := _get_button_index(object_type)
	_buttons[index].visible = true


func exclude(object_type: int) -> void:
	assert(_button_index_to_object_type_dict.values().has(object_type))
	var index := _get_button_index(object_type)
	_buttons[index].visible = false


func include_all() -> void:
	for object_type in _button_index_to_object_type_dict.values():
		include(object_type)


func exclude_all() -> void:
	for object_type in _button_index_to_object_type_dict.values():
		exclude(object_type)


func _on_button_down(button_index: int) -> void:
	var object_type = _button_index_to_object_type_dict[button_index]
	object_grabbed.emit(object_type)


func _get_button_index(button_type: int) -> int:
	return _button_index_to_object_type_dict.find_key(button_type)
