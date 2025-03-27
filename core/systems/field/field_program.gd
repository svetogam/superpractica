# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name FieldProgram
extends Mode

var field: Field:
	get:
		assert(_target != null)
		return _target


## Return true to continue with the action and false to cancel it.
# Virtual
func _before_action(_action: FieldAction) -> bool:
	return true


# Virtual
func _after_action(_action: FieldAction) -> void:
	return
