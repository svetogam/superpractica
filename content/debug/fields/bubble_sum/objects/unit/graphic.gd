##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends ProceduralGraphic

var selected := false


func _draw() -> void:
	var center = Vector2(0, 0)
	var radius = 15
	var outline_width = 2
	var outline_color = Color(0.0, 0.0, 0.0)
	var fill_color
	if selected:
		fill_color = GameGlobals.COLOR_HIGHLIGHT
	else:
		fill_color = Color(0.4, 0.4, 0.4)

	draw_circle(center, radius, fill_color)
	draw_arc(center, radius, 0, 2*PI, 100, outline_color, outline_width)
