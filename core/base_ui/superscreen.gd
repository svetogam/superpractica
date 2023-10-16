##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name Superscreen
extends Control

var input_sequencer := InputSequencer.new(self)


func _init() -> void:
	rect_clip_content = true
	size_flags_horizontal = SIZE_EXPAND_FILL
	size_flags_vertical = SIZE_EXPAND_FILL
	anchor_right = ANCHOR_END
	anchor_bottom = ANCHOR_END
	add_to_group("superscreens")


func set_offset(offset: Vector2) -> void:
	for child in get_children():
		if child is Node2D:
			child.position += offset
		elif child is Control:
			child.rect_position += offset


func get_object_list() -> Array:
	return ContextUtils.get_children_in_group(self, "superscreen_objects")


func get_object(object_name: String) -> Node2D:
	for object in get_object_list():
		if object.name == object_name:
			return object
	return null


func get_window_list() -> Array:
	return ContextUtils.get_children_in_group(self, "windows")


func get_window(window_name: String) -> Node2D:
	return get_object(window_name)


func get_windows_at_point(point: Vector2) -> Array:
	var window_list = []
	for window in get_window_list():
		if window.has_point(point):
			window_list.append(window)
	return window_list


func get_window_content(window_name: String, content_name: String) -> Control:
	var window = get_window(window_name)
	if window == null:
		return null
	return window.get_content(content_name)


func get_top_window_at_point(point: Vector2) -> Node2D:
	var window_list = _get_sorted_window_list_at_point(point)
	if not window_list.empty():
		return window_list.front()
	return null


func _get_sorted_window_list_at_point(point: Vector2) -> Array:
	var window_list = get_windows_at_point(point)
	window_list.sort_custom(self, "_sort_by_input_priority")
	return window_list


func _sort_by_input_priority(window_1: Node2D, window_2: Node2D) -> bool:
	return window_1.has_input_priority_over_other(window_2)


func get_top_subscreen_viewer_at_point(point: Vector2) -> Control:
	var top_window = get_top_window_at_point(point)
	if top_window != null:
		return top_window.get_subscreen_viewer_at_point(point)
	return null


func get_subscreen_list() -> Array:
	return ContextUtils.get_children_in_group(self, "subscreens")


func get_top_subscreen_at_point(point: Vector2) -> Node2D:
	var top_window = get_top_window_at_point(point)
	if top_window != null:
		return top_window.get_subscreen_at_point(point)
	return null


func convert_point_between_subscreen_viewers(point: Vector2, source: SubscreenViewer,
			destination: SubscreenViewer) -> Vector2:
	if source != null and destination == null:
		return source.convert_internal_to_external_point(point)
	elif source == null and destination != null:
		return destination.convert_external_to_internal_point(point)
	elif source != null and destination != null:
		assert(false) #Not supported yet
		return Vector2.ZERO
	else:
		return point
