#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name WindowContent
extends Control

var superscreen: Superscreen:
	get = _get_superscreen
var window: SpWindow:
	get = _get_window
var taking_input := false


func _init() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	add_to_group("window_contents")


func take_input(event: SuperscreenInputEvent) -> void:
	_superscreen_input(event)


# Virtual
func _superscreen_input(_event: SuperscreenInputEvent) -> void:
	pass


func is_taking_input() -> bool:
	return taking_input


func has_point(superscreen_point: Vector2) -> bool:
	var superscreen_rect := get_global_rect()
	return superscreen_rect.has_point(superscreen_point)


func get_center() -> Vector2:
	return size/2


func get_origin() -> Vector2:
	return global_position


func get_global_center() -> Vector2:
	return global_position + size/2


func _get_window() -> SpWindow:
	if window == null:
		window = ContextUtils.get_parent_in_group(self, "windows")
		assert(window != null)
	return window


func _get_superscreen() -> Superscreen:
	if superscreen == null:
		superscreen = ContextUtils.get_parent_in_group(self, "superscreens")
		assert(superscreen != null)
	return superscreen
