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

var rect: Rect2


func _draw() -> void:
	var color := GameGlobals.COLOR_HIGHLIGHT
	color.a = 0.8
	draw_rect(rect, color, true)
