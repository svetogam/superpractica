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

var rect := Rect2(1, 1, 1, 1)


func _draw() -> void:
	var left_x = rect.position.x
	var top_y = rect.position.y
	var width = rect.size.x
	var height = rect.size.y

	var outline_width = 5
	var outline_color = Color(0.0, 0.0, 0.0)
	var fill_color = Color(0.9, 0.9, 0.9)

	#draw board
	draw_rect(rect, fill_color, true)
	draw_rect(rect, outline_color, false, outline_width)

	#draw horizontal lines
	var y_position = top_y
	for _i in range(9):
		y_position += height/10
		var start = Vector2(left_x, y_position)
		var end = Vector2(left_x + width, y_position)
		draw_line(start, end, outline_color, outline_width)

	#draw vertical lines
	var x_position = left_x
	for _i in range(9):
		x_position += width/10
		var start = Vector2(x_position, top_y)
		var end = Vector2(x_position, top_y + height)
		draw_line(start, end, outline_color, outline_width)
