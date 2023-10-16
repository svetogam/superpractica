##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name InterfieldObject
extends SuperscreenObject

var original: SubscreenObject = null
var graphic: Node2D = null
var object_type := GameGlobals.NO_OBJECT


func _init() -> void:
	_drag_only = true


func setup(p_original: SubscreenObject =null, p_graphic: Node2D =null,
			p_input_shape: InputShape =null, p_object_type:=GameGlobals.NO_OBJECT) -> void:
	if p_original != null:
		original = p_original
		original.on_interfield_drag_started()
	if p_graphic != null:
		graphic = p_graphic.duplicate()
		add_child(graphic)
	if p_input_shape != null:
		input_shape.set_by_input_shape(p_input_shape)
	if p_object_type != GameGlobals.NO_OBJECT:
		object_type = p_object_type


func _on_drop(_point: Vector2) -> void:
	superscreen.process_interfield_object_drop(self)


func get_source() -> Subscreen:
	if original != null:
		return original.field
	return null
