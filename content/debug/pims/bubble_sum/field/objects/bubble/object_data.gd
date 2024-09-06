#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldObjectData


func _init() -> void:
	field_type = "BubbleSum"
	object_type = BubbleSum.Objects.BUBBLE
	name_text = "Bubble"
	drag_sprite = preload("graphic.gd")
	icon = null
