#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends FieldObject

var selected := false
@onready var _graphic := %Graphic as ProceduralGraphic


func _get_object_type() -> int:
	return BubbleSum.Objects.UNIT


func toggle_select() -> void:
	set_selected(not selected)


func set_selected(value: bool) -> void:
	selected = value
	_graphic.set_properties({"selected": value})


func is_inside_bubble(bubble: FieldObject) -> bool:
	return bubble.has_point(position)


func get_drag_graphic() -> ProceduralGraphic:
	return _graphic
