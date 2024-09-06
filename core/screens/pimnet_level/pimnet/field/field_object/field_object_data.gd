#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name FieldObjectData
extends Resource

var object_type: int = Game.NO_OBJECT
var field_type := ""
var name_text := ""
var drag_sprite: Resource
var icon: Texture2D


func is_draggable() -> bool:
	return drag_sprite != null


func new_sprite() -> Node2D:
	assert(is_draggable())

	if drag_sprite is GDScript:
		return drag_sprite.new()
	elif drag_sprite is PackedScene:
		return drag_sprite.instantiate()
	assert(false)
	return null