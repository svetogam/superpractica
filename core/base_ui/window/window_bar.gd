##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends SuperscreenObject

const BAR_HEIGHT := 30
const ACTIVE_BAR_COLOR := Color(.2, .2, .2)
const INACTIVE_BAR_COLOR := Color(.5, .5, .5)
var _enable_drag := true
onready var _color_rect := $"%ColorRect"


func _ready() -> void:
	set_color(true)


func setup_shape(window_size: Vector2) -> void:
	var rect_size = Vector2(window_size.x, BAR_HEIGHT)
	input_shape.set_rect(rect_size, false)
	_color_rect.rect_size = rect_size


func set_drag_enabled(enable:=true) -> void:
	_enable_drag = enable


func set_color(active: bool) -> void:
	if active:
		_color_rect.color = ACTIVE_BAR_COLOR
	else:
		_color_rect.color = INACTIVE_BAR_COLOR


func _on_press(_point: Vector2) -> void:
	if _enable_drag:
		start_grab()
	stop_active_input()


func _on_drag(_point: Vector2, _change: Vector2) -> void:
	stop_active_input()
