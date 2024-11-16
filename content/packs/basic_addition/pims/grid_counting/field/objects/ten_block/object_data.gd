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
	field_type = "GridCounting"
	object_type = GridCounting.Objects.TEN_BLOCK
	name_text = "Ten Block"
	drag_sprite = preload("sprite.tscn")
	icon = preload("res://content/packs/basic_addition/pims/grid_counting/graphics/ten_block_icon.svg")
