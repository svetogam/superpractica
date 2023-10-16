##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name Subscreen
extends Node2D

export(Color) var _background_color: Color
export(bool) var _pan_camera_on_drag := false
export(Vector2) var _default_size := Vector2.ZERO
var _camera: Camera2D
var _rect: Rect2
var _locator := ContextualLocator.new(self)
onready var _panner := $"%CameraPanner"
onready var _background := $"%Background"


func _enter_tree() -> void:
	_locator.auto_set("subscreen_camera", "_camera")


func get_camera() -> Camera2D:
	return _camera


func _ready() -> void:
	_background.color = _background_color
	if _default_size != Vector2.ZERO:
		set_rect(Vector2.ZERO, _default_size)


func take_input(event: SubscreenInputEvent) -> void:
	_superscreen_input(event)
	if _pan_camera_on_drag and not event.is_completed():
		_panner.take_input(event)


#Virtual
func _superscreen_input(_event: SubscreenInputEvent) -> void:
	pass


func get_object_list() -> Array:
	return ContextUtils.get_children_in_group(self, "subscreen_objects")


func get_object(object_name: String) -> Node2D:
	for object in get_object_list():
		if object.name == object_name:
			return object
	return null


func set_rect(pos: Vector2, size: Vector2) -> void:
	_rect = Rect2(pos, size)


func get_rect() -> Rect2:
	return _rect


func get_center() -> Vector2:
	return (_rect.end + _rect.position)/2


func has_point(point: Vector2) -> bool:
	return _rect.has_point(point)


func update_to_camera(camera_rect: Rect2) -> void:
	_set_panner_to_camera(camera_rect)
	_set_background_to_camera(camera_rect)


func _set_panner_to_camera(camera_rect: Rect2) -> void:
	_panner.position = camera_rect.position
	_panner.input_shape.set_rect(camera_rect.size, false)


func _set_background_to_camera(camera_rect: Rect2) -> void:
	_background.rect_position = camera_rect.position
	_background.rect_size = camera_rect.size
