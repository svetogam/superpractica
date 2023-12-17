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

const COLOR := Color(0, 0, 0)
const ARROWHEAD_WIDTH := 12.0
const ARROWHEAD_LENGTH := 10.0

var tip_point: Vector2
var direction: String


func _draw() -> void:
	var base_point_1: Vector2
	var base_point_2: Vector2

	if direction == "right":
		base_point_1 = Vector2(tip_point.x - ARROWHEAD_LENGTH,
							   tip_point.y - ARROWHEAD_WIDTH/2)
		base_point_2 = Vector2(tip_point.x - ARROWHEAD_LENGTH,
							   tip_point.y + ARROWHEAD_WIDTH/2)
	elif direction == "left":
		base_point_1 = Vector2(tip_point.x + ARROWHEAD_LENGTH,
							   tip_point.y - ARROWHEAD_WIDTH/2)
		base_point_2 = Vector2(tip_point.x + ARROWHEAD_LENGTH,
							   tip_point.y + ARROWHEAD_WIDTH/2)
	elif direction == "down":
		base_point_1 = Vector2(tip_point.x - ARROWHEAD_WIDTH/2,
							   tip_point.y - ARROWHEAD_LENGTH)
		base_point_2 = Vector2(tip_point.x + ARROWHEAD_WIDTH/2,
							   tip_point.y - ARROWHEAD_LENGTH)
	elif direction == "up":
		base_point_1 = Vector2(tip_point.x - ARROWHEAD_WIDTH/2,
							   tip_point.y + ARROWHEAD_LENGTH)
		base_point_2 = Vector2(tip_point.x + ARROWHEAD_WIDTH/2,
							   tip_point.y + ARROWHEAD_LENGTH)

	draw_colored_polygon([tip_point, base_point_1, base_point_2], COLOR)
