#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends ProceduralGraphic

var size: Vector2


func _draw() -> void:
	var top_left := Vector2(-(size.x/2), -(size.y/2))
	var rect := Rect2(top_left, size)
	var color := Color(0.0, 0.0, 0.0)

	draw_rect(rect, color)
