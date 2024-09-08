#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name FieldObjectMode
extends Mode

var object: FieldObject:
	get:
		assert(_target != null)
		return _target
var field: Field:
	get:
		assert(object.field != null)
		return object.field


# Virtual
func _hover(_held_object: FieldObject) -> void:
	pass


# Virtual
func _unhover() -> void:
	pass


# Virtual
func _press(_point: Vector2) -> void:
	pass


# Virtual
func _release(_point: Vector2) -> void:
	pass


# Virtual
func _drag(_point: Vector2, _change: Vector2) -> void:
	pass


# Virtual
func _drop(_point: Vector2) -> void:
	pass


# Virtual
func _take_drop(_dropped_object: FieldObject, _point: Vector2) -> void:
	pass
