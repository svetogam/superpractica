#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name InterfieldObject
extends SuperscreenObject

var original: FieldObject = null
var graphic: ProceduralGraphic = null
var object_type := GameGlobals.NO_OBJECT


func _init() -> void:
	_drag_only = true


func setup_by_original(p_original: FieldObject) -> void:
	original = p_original
	object_type = original.object_type
	graphic = original.get_drag_graphic().duplicate()
	add_child(graphic)
	original.on_interfield_drag_started()


func setup_by_parts(p_object_type := GameGlobals.NO_OBJECT,
		p_graphic: ProceduralGraphic = null
) -> void:
	object_type = p_object_type
	graphic = p_graphic.duplicate()
	add_child(graphic)


func _on_drop(_point: Vector2) -> void:
	superscreen.process_interfield_object_drop(self)


func get_source() -> Field:
	if original != null:
		return original.field
	return null
