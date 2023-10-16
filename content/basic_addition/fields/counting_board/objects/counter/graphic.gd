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
var transparent := false
var warning := false
var affirmation := false


func _draw() -> void:
	var center = Vector2(0, 0)
	var radius = 15
	var outline_width = 2
	var fill_color
	var outline_color

	if not selected:
		fill_color = Color(0.4, 0.4, 0.4, 1.0)
		outline_color = Color(0.0, 0.0, 0.0, 1.0)
	else:
		fill_color = GameGlobals.COLOR_HIGHLIGHT
		outline_color = Color(0.0, 0.0, 0.0, 1.0)
	if warning:
		fill_color = fill_color.blend(GameGlobals.COLOR_WARNING)
	if transparent:
		fill_color.a = 0.7
		outline_color.a = 0.7
	if affirmation:
		fill_color = GameGlobals.COLOR_AFFIRMATION

	draw_circle(center, radius, fill_color)
	if not warning:
		draw_arc(center, radius, 0, 2*PI, 100, outline_color, outline_width)
