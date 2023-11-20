##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name ObjectSpawner
extends SuperscreenObject

@export var _graphic: ProceduralGraphic
var _object_type: int


func _on_press(_point: Vector2) -> void:
	create_interfield_object(true)
	stop_active_input()


func create_interfield_object(grab_now: bool) -> InterfieldObject:
	var object = superscreen.create_interfield_object_by_parts(
			_graphic, input_shape, _object_type, grab_now)
	object.position = global_position
	return object


func set_object_type(p_object_type: int) -> void:
	_object_type = p_object_type


func get_object_type() -> int:
	return _object_type
