##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name InputShape
extends RefCounted

enum ShapeTypes {RECT, CIRCLE}

var _shape: int = ShapeTypes.RECT
var _radius: float = 0
var _rect_size: Vector2
var _position: Vector2


func set_by_data(data: InputShapeSetupResource) -> void:
	assert(data != null)
	match data.shape_type:
		ShapeTypes.RECT:
			set_rect(data.size, data.rect_center, data.offset)
		ShapeTypes.CIRCLE:
			set_circle(data.circle_radius, data.offset)
		_:
			assert(false)


func set_by_input_shape(other: InputShape) -> void:
	assert(other != null)
	_shape = other._shape
	_radius = other._radius
	_rect_size = other._rect_size
	_position = other._position


func set_rect(size: Vector2, centered:=true, offset:=Vector2.ZERO) -> void:
	_shape = ShapeTypes.RECT
	if centered:
		_position = offset - size/2
	else:
		_position = offset
	_rect_size = size


func set_circle(p_radius: float, offset:=Vector2.ZERO) -> void:
	_shape = ShapeTypes.CIRCLE
	_position = offset
	_radius = p_radius


func has_point(point: Vector2) -> bool:
	if _shape == ShapeTypes.RECT:
		return get_rect().has_point(point)
	elif _shape == ShapeTypes.CIRCLE:
		return _position.distance_to(point) <= _radius
	else:
		assert(false)
		return false


func get_rect() -> Rect2:
	return Rect2(_position, _rect_size)


func get_radius() -> float:
	return _radius
