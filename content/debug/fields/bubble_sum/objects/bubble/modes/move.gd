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

var _moving := false
var _drag_list: Array


func _on_press(_field_point: Vector2) -> void:
	_moving = true
	_drag_list = object.get_internal_objects()
	object.start_grab()

	object.stop_active_input()


func _on_drag(_field_point: Vector2, field_change: Vector2) -> void:
	if _moving:
		_drag_by(field_change)
		object.stop_active_input()


func _on_drop(_field_point: Vector2) -> void:
	if _moving:
		if field.has_point(object.position):
			field.push_action("empty")
		else:
			object.revert_drag()
			_revert_dragged_objects()
			_drag_list.clear()
			object.stop_grab()

		_moving = false
		object.stop_active_input()


func _drag_by(delta_vector: Vector2) -> void:
	object.translate(delta_vector)

	for sub_object in _drag_list:
		sub_object.translate(delta_vector)


func _revert_dragged_objects() -> void:
	var drag_vector = object.get_total_drag_vector()
	for object in _drag_list:
		object.translate(-drag_vector)
