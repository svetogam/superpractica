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

var radius := 0
var bounds := []
var selected := false


func _draw() -> void:
	var center = Vector2(0, 0)

	if selected:
		var color = GameGlobals.COLOR_HIGHLIGHT
		draw_circle_arc_poly(center, bounds[0], bounds[1], color)


func draw_circle_arc_poly(center: Vector2, angle_from: float, angle_to: float,
			color: Color) -> void:
	if angle_from > angle_to:
		angle_to += TAU

	var points_number = 32
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])

	for i in range(points_number + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / points_number - PI/2
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
	draw_polygon(points_arc, colors)
