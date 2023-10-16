##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name InputSequencer
extends Reference

signal input_processed

var _grabbed_object: Node2D = null
var _grabbed_subscreen_viewer: Control
var _superscreen: Control
var _enabled := true


func _init(p_superscreen: Control) -> void:
	_superscreen = p_superscreen
	_superscreen.connect("gui_input", self, "_on_superscreen_input")


func set_enabled(p_enabled:=true) -> void:
	_enabled = p_enabled


func _on_superscreen_input(gd_event: InputEvent) -> void:
	assert(gd_event != null)
	if _enabled:
		var event = SuperscreenInputEvent.new(gd_event, _grabbed_object)
		_process_input(event)


func _process_input(event: SuperscreenInputEvent) -> void:
	_give_input_to_grabbed_object(event)
	if not event.is_completed():
		_give_input_to_top_window(event)
	event.complete()

	emit_signal("input_processed")


func _give_input_to_grabbed_object(event: SuperscreenInputEvent) -> void:
	if _grabbed_object != null:
		if _grabbed_subscreen_viewer != null:
			var subscreen_event = event.make_subscreen_input_event(_grabbed_subscreen_viewer)
			_grabbed_object.take_input(subscreen_event)
		else:
			_grabbed_object.take_input(event)


func _give_input_to_top_window(event: SuperscreenInputEvent) -> void:
	var top_window = _superscreen.get_top_window_at_point(event.get_position())
	if top_window != null:
		top_window.take_input(event)


func connect_input_object(input_object: Node2D, subscreen_viewer: Control =null) -> void:
	input_object.connect("grab_started", self, "_on_grab_started", [input_object, subscreen_viewer])
	input_object.connect("grab_stopped", self, "_on_grab_stopped", [input_object])


func _on_grab_started(object: Node2D, subscreen_viewer: Control) -> void:
	_grabbed_object = object
	_grabbed_subscreen_viewer = subscreen_viewer


func _on_grab_stopped(object: Node2D) -> void:
	if _grabbed_object == object:
		_grabbed_object = null
		_grabbed_subscreen_viewer = null


func get_grabbed_object() -> Node2D:
	return _grabbed_object
