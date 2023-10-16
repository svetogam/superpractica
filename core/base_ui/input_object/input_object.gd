##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name InputObject
extends Node2D

signal hovered(point, initial, grabbed_object)
signal unhovered()
signal pressed(point)
signal dragged(point, change)
signal dropped(point)
signal grab_started
signal grab_stopped

export(int) var input_priority := 0
export(Resource) var _input_shape_setup_data: Resource
var input_shape := InputShape.new()
var _previously_hovered := false
var _current_event: SpInputEvent
var _position_before_grab: Vector2


func _init() -> void:
	add_to_group("input_objects")


func _ready() -> void:
	if _input_shape_setup_data != null:
		input_shape.set_by_data(_input_shape_setup_data)


func take_input(event: SpInputEvent) -> void:
	_superscreen_input(event)


#Virtual default
func _superscreen_input(event: SpInputEvent) -> void:
	assert(not event.is_completed())

	_current_event = event
	var point = event.get_position()
	var hovered = has_point(point)
	var changed_hover = hovered != _previously_hovered
	var grabbed_object = event.get_grabbed_object()
	var grabbed = grabbed_object == self

	if hovered and not grabbed:
		_on_hover(point, changed_hover, grabbed_object)
		emit_signal("hovered", point, changed_hover, grabbed_object)
	elif not hovered and changed_hover:
		_on_unhover()
		emit_signal("unhovered")

	if event.is_active():
		if hovered and event.is_press():
			_on_press(point)
			emit_signal("pressed", point)
		elif grabbed and event.is_motion():
			var drag_change = event.get_change()
			_on_drag(point, drag_change)
			emit_signal("dragged", point, drag_change)
		elif grabbed and event.is_release():
			_on_drop(point)
			emit_signal("dropped", point)
			_end_drag()

	_previously_hovered = hovered


#Virtual default
func has_point(point: Vector2) -> bool:
	var relative_point = point - global_position
	return input_shape.has_point(relative_point)


#Virtual
func _on_hover(_point: Vector2, _initial: bool, _grabbed_object: Node2D) -> void:
	pass


#Virtual
func _on_unhover() -> void:
	pass


#Virtual
func _on_press(_point: Vector2) -> void:
	pass


#Virtual
func _on_drag(_point: Vector2, _change: Vector2) -> void:
	pass


#Virtual
func _on_drop(_point: Vector2) -> void:
	pass


func _end_drag() -> void:
	stop_grab()
	if _current_event.is_active():
		stop_active_input()


func start_grab() -> void:
	_position_before_grab = position
	emit_signal("grab_started")


func stop_grab() -> void:
	emit_signal("grab_stopped")


func revert_drag() -> void:
	position = _position_before_grab


func get_total_drag_vector() -> Vector2:
	return position - _position_before_grab


func stop_active_input() -> void:
	assert(_current_event.is_active())
	assert(not _current_event.is_completed())

	_current_event.deactivate()


func _stop_all_input() -> void:
	assert(not _current_event.is_completed())

	_current_event.complete()


func has_input_priority_over_other(other: Node2D) -> bool:
	if input_priority > other.input_priority:
		return true
	elif input_priority == other.input_priority:
		if z_index > other.z_index:
			return true
		elif z_index == other.z_index:
			if get_index() > other.get_index():
				return true
	return false
