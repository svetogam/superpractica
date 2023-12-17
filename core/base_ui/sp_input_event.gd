#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name SpInputEvent
extends RefCounted

signal completed
signal deactivated

enum InputType {
	EMPTY,
	PRESS,
	RELEASE,
	MOTION,
}
enum InputState {
	ACTIVE,
	INACTIVE,
	COMPLETED,
}

var _input_type := InputType.EMPTY
var _position: Vector2
var _relative: Vector2
var _grabbed_object: InputObject
var _input_state := InputState.ACTIVE


func is_press() -> bool:
	return _input_type == InputType.PRESS


func is_release() -> bool:
	return _input_type == InputType.RELEASE


func is_motion() -> bool:
	return _input_type == InputType.MOTION


func get_position() -> Vector2:
	return _position


func get_change() -> Vector2:
	if _input_type == InputType.MOTION:
		return _relative
	else:
		return Vector2.ZERO


func get_grabbed_object() -> InputObject:
	return _grabbed_object


func is_object_grabbed() -> bool:
	return _grabbed_object != null


func deactivate() -> void:
	if is_active():
		_input_state = InputState.INACTIVE
		deactivated.emit()
	elif is_completed():
		assert(false)


func complete() -> void:
	_input_state = InputState.COMPLETED
	completed.emit()


func is_active() -> bool:
	return _input_state == InputState.ACTIVE


func is_completed() -> bool:
	return _input_state == InputState.COMPLETED
