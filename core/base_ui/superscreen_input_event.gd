##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name SuperscreenInputEvent
extends SpInputEvent


func _init(event: InputEvent, p_grabbed_object: Node2D =null) -> void:
	if event == null:
#		assert(false)
		return

	if _is_godot_primary_mouse_press(event):
		_input_type = InputType.PRESS
	elif _is_godot_primary_mouse_release(event):
		_input_type = InputType.RELEASE
	elif event is InputEventMouseMotion:
		_input_type = InputType.MOTION
		_relative = event.relative
	else:
		return
	_position = event.position

	_grabbed_object = p_grabbed_object


func _is_godot_primary_mouse_press(event: InputEvent) -> bool:
	return (event is InputEventMouseButton and event.is_pressed()
			and event.button_index == BUTTON_LEFT)


func _is_godot_primary_mouse_release(event: InputEvent) -> bool:
	return (event is InputEventMouseButton and not event.is_pressed()
			and event.button_index == BUTTON_LEFT)


func make_subscreen_input_event(subscreen_viewer: Control) -> SubscreenInputEvent:
	assert(subscreen_viewer != null)

	var subscreen_position = subscreen_viewer.convert_external_to_internal_point(_position)
	var subscreen_relative = subscreen_viewer.convert_external_to_internal_vector(_relative)
	var subscreen_event = SubscreenInputEvent.new(_input_type, subscreen_position,
			subscreen_relative, _grabbed_object, _input_state)

	subscreen_event.connect("completed", self, "complete")
	subscreen_event.connect("deactivated", self, "deactivate")

	return subscreen_event
