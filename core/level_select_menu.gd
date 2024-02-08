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

@onready var _menu := %TwoTierMenu as TwoTierMenu
@onready var _quit_button := %Quit as Button


func _ready() -> void:
	for level_group in Game.level_loader.get_level_groups():
		_add_level_group(level_group)

	_set_section_to_most_recent()

	_menu.leaf_button_pressed.connect(_on_leaf_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)


func _add_level_group(level_group: LevelGroupResource) -> void:
	var level_group_text := level_group.get_name_text()
	var section_index := _menu.add_section(level_group_text)

	for level_name in level_group.get_level_names():
		var text = level_group.get_level_name_text(level_name)
		_menu.add_leaf(section_index, text)


func _set_section_to_most_recent() -> void:
	var most_recent_group := Game.level_loader.loaded_level_group
	if most_recent_group != null:
		var index := _get_section_index_of_level_group(most_recent_group.name)
		_menu.set_section(index)


func _get_section_index_of_level_group(level_group_name: String) -> int:
	var level_groups := Game.level_loader.get_level_groups()
	for i in level_groups.size():
		if level_groups[i].name == level_group_name:
			return i
	return -1


func _on_leaf_button_pressed(section_index: int, leaf_index: int) -> void:
	var group = Game.level_loader.get_level_groups()[section_index]
	var group_name = group.name
	var level_name = group.get_level_names()[leaf_index]
	Game.level_loader.enter_level(group_name, level_name)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
