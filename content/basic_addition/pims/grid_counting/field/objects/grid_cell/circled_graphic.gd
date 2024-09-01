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

const NORMAL_COLOR := Color(0.4, 0.4, 0.4)
var rect: Rect2
var variant := "normal"


func _draw() -> void:
	var center := Vector2.ZERO
	var width := 3.0
	var outline_width := 1.5
	var outline_color := Color(0, 0, 0)
	var radius := rect.size.x/2 - width
	var color: Color
	if variant == "warning":
		color = GameGlobals.COLOR_REJECTION
	elif variant == "affirmation":
		color = GameGlobals.COLOR_AFFIRMATION
	elif variant == "normal":
		color = NORMAL_COLOR
	else:
		assert(false)

	draw_arc(center, radius, -1, 2*PI, 30, outline_color, width + outline_width*2)
	draw_arc(center, radius, -1, 2*PI, 30, color, width)
