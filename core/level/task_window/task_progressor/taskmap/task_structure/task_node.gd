##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Control

@export var id: String
var completed := false
var structure: Control = null
var grid_position: Vector2
@onready var _label := %Label as Label
@onready var _check_box := %CheckBox as CheckBox


func set_label(text: String) -> void:
	_label.text = text


func set_completed() -> void:
	completed = true
	_check_box.button_pressed = true


func set_grid_position(column: int, row: int) -> void:
	grid_position = Vector2(column, row)


func get_left_point() -> Vector2:
	var struct_position = _get_position_in_structure()
	return Vector2(struct_position.x, struct_position.y + (size.y / 2))


func get_right_point() -> Vector2:
	var struct_position = _get_position_in_structure()
	return Vector2(struct_position.x + size.x, struct_position.y + (size.y / 2))


func get_top_point() -> Vector2:
	var struct_position = _get_position_in_structure()
	return Vector2(struct_position.x + (size.x / 2), struct_position.y)


func get_bottom_point() -> Vector2:
	var struct_position = _get_position_in_structure()
	return Vector2(struct_position.x + (size.x / 2), struct_position.y + size.y)


func _get_position_in_structure() -> Vector2:
	return structure.get_task_position(self)
