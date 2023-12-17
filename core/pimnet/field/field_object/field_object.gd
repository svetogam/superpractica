#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name FieldObject
extends SubscreenObject

var field: Field:
	set = _do_not_set,
	get = _get_field
var object_type: int:
	set = _do_not_set,
	get = _get_object_type
@onready var _modes := $ActiveModes as ModeGroup


# Virtual
func _get_object_type() -> int:
	return GameGlobals.NO_OBJECT


func _ready() -> void:
	super()

	update_active_modes()
	field.tool_changed.connect(update_active_modes)

	if field.is_ready():
		_on_field_ready()
	else:
		field.ready.connect(_on_field_ready)


# Virtual
func _on_field_ready() -> void:
	pass


# Virtual
func on_interfield_drag_started() -> void:
	hide()


# Virtual
func on_interfield_drag_stopped() -> void:
	move_to_front()
	show()


# Virtual
func get_drag_graphic() -> ProceduralGraphic:
	return null


# Virtual
func _on_hover(point: Vector2, initial: bool, grabbed_object: InputObject) -> void:
	for mode in _modes.get_active_modes():
		mode._on_hover(point, initial, grabbed_object)


# Virtual
func _on_unhover() -> void:
	for mode in _modes.get_active_modes():
		mode._on_unhover()


# Virtual
func _on_press(point: Vector2) -> void:
	for mode in _modes.get_active_modes():
		if _current_event.is_active():
			mode._on_press(point)


# Virtual
func _on_drag(point: Vector2, change: Vector2) -> void:
	for mode in _modes.get_active_modes():
		if _current_event.is_active():
			mode._on_drag(point, change)


# Virtual
func _on_drop(point: Vector2) -> void:
	for mode in _modes.get_active_modes():
		if _current_event.is_active():
			mode._on_drop(point)


func update_active_modes(_new_tool := "") -> void:
	var active_modes := field.get_active_modes_for_object(object_type)
	_modes.set_by_list(active_modes)


func is_mode_active(mode: String) -> bool:
	return _modes.is_active(mode)


func _get_field() -> Field:
	assert(_subscreen != null)
	return _subscreen


static func _do_not_set(_value: Variant) -> void:
	assert(false)
