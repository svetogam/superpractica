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
	set = _do_not_set,
	get = _get_object
var field: Field:
	set = _do_not_set,
	get = _get_field


# Virtual
func _on_hover(_point: Vector2, _initial: bool, _grabbed_object: InputObject) -> void:
	pass


# Virtual
func _on_unhover() -> void:
	pass


# Virtual
func _on_press(_point: Vector2) -> void:
	pass


# Virtual
func _on_drag(_point: Vector2, _change: Vector2) -> void:
	pass


# Virtual
func _on_drop(_point: Vector2) -> void:
	pass


func _get_object() -> FieldObject:
	assert(_target != null)
	return _target


func _get_field() -> Field:
	assert(object.field != null)
	return object.field


static func _do_not_set(_value: Variant) -> void:
	assert(false)
