##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name WindowContent
extends Control

var superscreen: Control
var window: Node2D
var taking_input := false


func _init() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	add_to_group("window_contents")


func _enter_tree():
	_find_window()
	_find_superscreen()


func _find_window() -> void:
	window = ContextUtils.get_parent_in_group(self, "windows")
	assert(window != null)


func _find_superscreen() -> void:
	superscreen = ContextUtils.get_parent_in_group(self, "superscreens")
	assert(superscreen != null)


func take_input(event: SuperscreenInputEvent) -> void:
	_superscreen_input(event)


#Virtual
func _superscreen_input(_event: SuperscreenInputEvent) -> void:
	pass


func is_taking_input() -> bool:
	return taking_input


func has_point(superscreen_point: Vector2) -> bool:
	var superscreen_rect = get_global_rect()
	return superscreen_rect.has_point(superscreen_point)


func get_center() -> Vector2:
	return rect_size/2


func get_origin() -> Vector2:
	return rect_global_position


func get_global_center() -> Vector2:
	return rect_global_position + rect_size/2
