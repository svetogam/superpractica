##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldObjectMode

var _resizing := false
var _direction := ""


func _start() -> void:
	if object.handle_control != null:
		object.handle_control.show_handles()
		object.handle_control.connect("handle_pressed", self, "_on_handle_pressed")


func _on_handle_pressed(p_direction: String) -> void:
	_resizing = true
	_direction = p_direction
	object.start_grab()


func _on_drag(_field_point: Vector2, field_change: Vector2) -> void:
	if _resizing:
		object.resize_by(_direction, field_change)
		object.stop_active_input()


func _on_drop(_field_point: Vector2) -> void:
	if _resizing:
		_resizing = false
		object.stop_grab()
		_direction = ""

		field.push_action("resize_bubble", [object, object.radius])
		object.stop_active_input()


func _end() -> void:
	if object.handle_control != null:
		object.handle_control.hide_handles()
		object.handle_control.disconnect("handle_pressed", self, "_on_handle_pressed")
