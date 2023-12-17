#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name SubscreenViewer
extends WindowContent

const DEFAULT_ZOOM := Vector2(1, 1)
var _subscreen: Subscreen
@onready var camera := %Camera as Camera2D
@onready var _viewport := %SubViewport as SubViewport
@onready var _scroll_bars := %ScrollBars as Control


func _ready() -> void:
	ContextualLocator.register_property_as(self, "camera", "subscreen_camera")

	for child in _viewport.get_children():
		if child.is_in_group("subscreens"):
			set_subscreen(child)


func set_subscreen(p_subscreen: Subscreen, p_camera_zoom := DEFAULT_ZOOM) -> void:
	_subscreen = p_subscreen
	camera.zoom = p_camera_zoom
	if not _viewport.is_ancestor_of(_subscreen):
		_viewport.add_child(_subscreen)

	_fit_to_subscreen()

	_viewport.size_changed.connect(_on_viewport_size_changed)
	_scroll_bars.position_changed.connect(_on_scroll_bars_position_changed)
	camera.moved.connect(_on_camera_moved)


func remove_subscreen() -> void:
	assert(_subscreen != null)

	_viewport.size_changed.disconnect(_on_viewport_size_changed)
	_scroll_bars.position_changed.disconnect(_on_scroll_bars_position_changed)
	camera.moved.disconnect(_on_camera_moved)

	_viewport.remove_child(_subscreen)
	_subscreen = null


func get_subscreen() -> Subscreen:
	return _subscreen


func _fit_to_subscreen() -> void:
	var subscreen_rect := _subscreen.get_rect()
	if subscreen_rect.size != Vector2.ZERO:
		camera.set_limits(subscreen_rect.position, subscreen_rect.end)
		_fit_scroll_bars_to_subscreen()
		_center_camera_on_subscreen()


func _fit_scroll_bars_to_subscreen() -> void:
	var subscreen_size := _subscreen.get_rect().size
	var camera_size = camera.get_rect().size
	_scroll_bars.set_scroll_bars(subscreen_size, camera_size)


func _center_camera_on_subscreen() -> void:
	var camera_rect = camera.get_rect()
	var scene_size := _subscreen.get_rect().size

	var camera_offset = camera_rect.position
	if scene_size.x < camera_rect.size.x:
		camera_offset.x = (scene_size.x - camera_rect.size.x) / 2
	if scene_size.y < camera_rect.size.y:
		camera_offset.y = (scene_size.y - camera_rect.size.y) / 2

	_set_camera_position(camera_offset)


func _set_camera_position(new_position: Vector2) -> void:
	camera.offset = new_position
	_scroll_bars.set_scroll_position(new_position)

	var camera_rect = camera.get_rect()
	_subscreen.update_to_camera(camera_rect)


func _on_viewport_size_changed() -> void:
	_fit_to_subscreen()


func _on_scroll_bars_position_changed(new_position: Vector2) -> void:
	_set_camera_position(new_position)


func _on_camera_moved() -> void:
	_scroll_bars.set_scroll_position(camera.offset)


func convert_external_to_internal_point(external_point: Vector2) -> Vector2:
	var local_point := _convert_external_to_local_point(external_point)
	return _convert_local_to_internal_point(local_point)


func convert_internal_to_external_point(internal_point: Vector2) -> Vector2:
	var local_point := _convert_internal_to_local_point(internal_point)
	return _convert_local_to_external_point(local_point)


func _convert_external_to_local_point(external_point: Vector2) -> Vector2:
	return external_point - get_origin()


func _convert_local_to_external_point(local_point: Vector2) -> Vector2:
	return local_point + get_origin()


func _convert_local_to_internal_point(local_point: Vector2) -> Vector2:
	return local_point / camera.zoom + camera.offset


func _convert_internal_to_local_point(internal_point: Vector2) -> Vector2:
	return (internal_point - camera.offset) * camera.zoom


func convert_external_to_internal_vector(external_vector: Vector2) -> Vector2:
	return external_vector / camera.zoom


func convert_internal_to_external_vector(internal_vector: Vector2) -> Vector2:
	return internal_vector * camera.zoom
