# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

## A [FieldObjectMode] hooks responses to particular affordances on [FieldObject]s.
##
## This is an extension of the interface in [FieldObject].
## See that documentation.

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
func _pressed(_point: Vector2) -> void:
	pass


# Virtual
func _released(_point: Vector2) -> void:
	pass


# Virtual
func _dragged(_external: bool, _point: Vector2, _change: Vector2) -> void:
	pass


# Virtual
func _dropped(_external: bool, _point: Vector2) -> void:
	pass


# Virtual
func _received(_external: bool, _dropped_object: FieldObject, _point: Vector2) -> void:
	pass


# Virtual
func _dropped_out(_receiver: Field) -> void:
	pass


# Virtual
func _hovered(_external: bool, _grabbed_object: FieldObject) -> void:
	pass


# Virtual
func _unhovered(_external: bool, _grabbed_object: FieldObject) -> void:
	pass
