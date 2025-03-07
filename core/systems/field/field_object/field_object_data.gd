# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name FieldObjectData
extends Resource

var object_type: int = Game.NO_OBJECT
var field_type := ""
var name_text := ""
var drag_sprite: Resource
var icon: Texture2D


func _init(p_field_type: String, p_object_type: int, p_name_text: String,
		p_drag_sprite: Resource = null, p_icon: Texture2D = null
) -> void:
	field_type = p_field_type
	object_type = p_object_type
	name_text = p_name_text
	drag_sprite = p_drag_sprite
	icon = p_icon


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
