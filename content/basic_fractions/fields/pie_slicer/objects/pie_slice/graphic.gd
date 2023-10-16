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

var vector := Vector2(0, 0)
var variant: int = PieSlicerGlobals.SliceVariants.NORMAL


func _draw() -> void:
	var center = Vector2(0, 0)
	var color
	var line_width
	match variant:
		PieSlicerGlobals.SliceVariants.NORMAL:
			color = Color(0.0, 0.0, 0.0)
			line_width = 3
		PieSlicerGlobals.SliceVariants.WARNING:
			color = Color(1.0, 0.0, 0.0)
			line_width = 5
		PieSlicerGlobals.SliceVariants.PREFIG:
			color = Color(0.2, 0.2, 0.2, 0.5)
			line_width = 2
		PieSlicerGlobals.SliceVariants.GUIDE:
			color = GameGlobals.COLOR_GUIDE
			color.a = 0.5
			line_width = 8

	draw_line(center, vector, color, line_width)
