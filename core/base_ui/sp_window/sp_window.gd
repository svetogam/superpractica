##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name SpWindow
extends SuperscreenObject

const CONTENT_PATH := "WindowRect/ContentPanel/ContentContainer/"
@export var _start_disabled := false
var _disabled := false
@onready var window_rect := %WindowRect as Control
@onready var _content_container := %ContentContainer as HBoxContainer


func _ready() -> void:
	super()
	input_shape.set_rect(window_rect.size, false)
	if _start_disabled:
		disable()


func add_content(content: WindowContent, left_side:=false) -> void:
	_content_container.add_child(content)
	if left_side and _content_container.get_child_count() > 0:
		_content_container.move_child(content, 0)


func remove_content(content_name: String) -> void:
	var content = get_content(content_name)
	assert(content != null)
	_content_container.remove_child(content)
	content.queue_free()


func set_to_top() -> void:
	move_to_front()


func disable(value: bool =true) -> void:
	_disabled = value


func _on_press(_point: Vector2) -> void:
	set_to_top()


func take_input(event: SpInputEvent) -> void:
	super.take_input(event)

	if not event.is_completed() and not _disabled:
		var subscreen_viewer = get_subscreen_viewer_at_point(event.get_position())
		var window_content = _get_input_taking_content_at_point(event.get_position())
		if subscreen_viewer != null:
			var subscreen = subscreen_viewer.get_subscreen()
			var subscreen_event = event.make_subscreen_input_event(subscreen_viewer)
			subscreen.take_input(subscreen_event)
		elif window_content != null:
			window_content.take_input(event)


func _get_input_taking_content_at_point(point: Vector2) -> WindowContent:
	for window_content in get_content_list_at_point(point):
		if window_content.is_taking_input():
			return window_content
	return null


func get_content(content_name: String) -> WindowContent:
	return get_node_or_null(CONTENT_PATH + content_name) as WindowContent


func get_subscreen_viewer_at_point(point: Vector2) -> SubscreenViewer:
	for subscreen_viewer in _get_subscreen_viewer_list():
		var viewer_rect = subscreen_viewer.get_global_rect()
		if viewer_rect.has_point(point):
			return subscreen_viewer
	return null


func get_subscreen_at_point(point: Vector2) -> Subscreen:
	var subscreen_viewer = get_subscreen_viewer_at_point(point)
	if subscreen_viewer != null:
		return subscreen_viewer.get_subscreen()
	return null


func get_content_list_at_point(point: Vector2) -> Array:
	var window_contents = []
	for window_content in _get_content_list():
		if window_content.has_point(point):
			window_contents.append(window_content)
	return window_contents


func _get_content_list() -> Array:
	return ContextUtils.get_children_in_group(self, "window_contents")


func _get_subscreen_viewer_list() -> Array:
	return ContextUtils.get_children_in_group(self, "subscreen_viewers")
