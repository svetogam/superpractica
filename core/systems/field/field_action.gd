# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name FieldAction
extends RefCounted

var field: Field
var name: String:
	get = get_name


# Virtual
static func get_name() -> String:
	assert(false)
	return ""


func _init(p_field: Field) -> void:
	field = p_field


# Virtual
func is_valid() -> bool:
	return true


# Virtual
func is_possible() -> bool:
	return true


# Virtual
func prefigure() -> void:
	pass


# Virtual
func unprefigure() -> void:
	pass


# Virtual
func do() -> void:
	assert(is_valid())


func push() -> void:
	unprefigure()
	field.action_queue.push(self)
