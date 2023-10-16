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


func _draw() -> void:
	var center = Vector2(0, 0)
	var radius = 200
	var outline_width = 5
	var outline_color = Color(0.0, 0.0, 0.0)
	var fill_color = Color(0.5, 0.5, 0.5)

	var center_point_radius = 4
	var center_point_color = Color(0.0, 0.0, 0.0)

	draw_circle(center, radius, fill_color)
	draw_arc(center, radius, 0, 2*PI, 100, outline_color, outline_width)
	draw_circle(center, center_point_radius, center_point_color)
