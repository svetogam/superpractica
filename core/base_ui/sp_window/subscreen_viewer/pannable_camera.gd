#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Camera2D

signal moved

var _pan_limit_left: float
var _pan_limit_right: float
var _pan_limit_top: float
var _pan_limit_bottom: float


func set_limits(top_left: Vector2, bottom_right: Vector2) -> void:
	_pan_limit_left = top_left.x
	_pan_limit_top = top_left.y
	_pan_limit_right = bottom_right.x
	_pan_limit_bottom = bottom_right.y

	_set_within_limits()


func move_by(position_delta: Vector2) -> void:
	var size := get_rect().size
	var pan_limit_width := _pan_limit_right - _pan_limit_left
	var pan_limit_height := _pan_limit_bottom - _pan_limit_top

	if size.x < pan_limit_width:
		offset.x += position_delta.x
	if size.y < pan_limit_height:
		offset.y += position_delta.y

	_set_within_limits()

	moved.emit()


func _set_within_limits() -> void:
	var size := get_rect().size
	var pan_limit_width := _pan_limit_right - _pan_limit_left
	var pan_limit_height := _pan_limit_bottom - _pan_limit_top

	if size.x < pan_limit_width:
		if offset.x < _pan_limit_left:
			offset.x = _pan_limit_left
		elif offset.x + size.x > _pan_limit_right:
			offset.x = _pan_limit_right - size.x
	if size.y < pan_limit_height:
		if offset.y < _pan_limit_top:
			offset.y = _pan_limit_top
		elif offset.y + size.y > _pan_limit_bottom:
			offset.y = _pan_limit_bottom - size.y


func get_rect() -> Rect2:
	var viewport_size = get_parent().size
	var camera_width = viewport_size.x / zoom.x
	var camera_height = viewport_size.y / zoom.y
	return Rect2(offset, Vector2(camera_width, camera_height))
