##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldObject

var _direction: String
var _bubble: FieldObject
var _context: Node2D
@onready var _graphic := %Graphic as ProceduralGraphic


func _enter_tree():
	super()
	_context = get_parent()


func _ready() -> void:
	super()
	_graphic.set_properties({"size": input_shape.get_rect().size})
	hide()


func setup(p_bubble: FieldObject, p_direction: String) -> void:
	_bubble = p_bubble
	_direction = p_direction


func _on_press(_point: Vector2) -> void:
	if is_visible_in_tree():
		_context.handle_pressed.emit(_direction)
		stop_active_input()


func update_position() -> void:
	match _direction:
		"DL":
			position = Vector2(-_bubble.radius, _bubble.radius)
		"L":
			position = Vector2(-_bubble.radius, 0)
		"UL":
			position = Vector2(-_bubble.radius, -_bubble.radius)
		"U":
			position = Vector2(0, -_bubble.radius)
		"UR":
			position = Vector2(_bubble.radius, -_bubble.radius)
		"R":
			position = Vector2(_bubble.radius, 0)
		"DR":
			position = Vector2(_bubble.radius, _bubble.radius)
		"D":
			position = Vector2(0, _bubble.radius)
