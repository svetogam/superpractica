#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

class_name TwoTierMenu
extends HBoxContainer

signal leaf_button_pressed(section_index, leaf_index)

@export var second_tier_columns: int = -1
var _sections: Array = []
var _button_group := ButtonGroup.new()
@onready var _first_container := %FirstTierContainer as GridContainer
@onready var _second_container := %SecondTierContainer as GridContainer


func _ready() -> void:
	if second_tier_columns >= 0:
		_second_container.columns = second_tier_columns


func add_section(text: String) -> int:
	var section_index := _sections.size()
	var section := _new_section(text)
	_sections.append(section)
	return section_index


func add_leaf(section_index: int, leaf_text: String) -> void:
	_sections[section_index].leaf_texts.append(leaf_text)


func _new_section(text: String) -> Dictionary:
	var section_index := _sections.size()
	var button := _add_section_button(section_index, text)
	return {"text": text, "button": button, "leaf_texts": []}


func _add_section_button(section_index: int, text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.toggle_mode = true
	button.custom_minimum_size.x = 240
	button.custom_minimum_size.y = 60
	button.button_group = _button_group
	button.pressed.connect(_on_section_button_pressed.bind(section_index))
	_first_container.add_child(button)
	return button


func _on_section_button_pressed(section_index: int) -> void:
	set_section(section_index)


func set_section(section_index: int) -> void:
	_clear_leaf_buttons()

	var section = _sections[section_index]
	section.button.button_pressed = true
	for leaf_index in section.leaf_texts.size():
		var button := _add_leaf_button()
		button.text = section.leaf_texts[leaf_index]
		button.pressed.connect(emit_signal.bind(
				"leaf_button_pressed", section_index, leaf_index))


func _clear_leaf_buttons() -> void:
	var buttons := _second_container.get_children()
	for button in buttons:
		_second_container.remove_child(button)


func _add_leaf_button() -> Button:
	var button := Button.new()
	button.custom_minimum_size.x = 160
	button.custom_minimum_size.y = 80
	_second_container.add_child(button)
	return button
