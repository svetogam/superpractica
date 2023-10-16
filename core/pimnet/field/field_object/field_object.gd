##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name FieldObject
extends SubscreenObject

var field: Subscreen
onready var _modes := $ActiveModes


func _ready() -> void:
	field = _subscreen

	update_active_modes()
	field.connect("tool_changed", self, "update_active_modes")

	if field.is_ready():
		_on_field_ready()
	else:
		field.connect("ready", self, "_on_field_ready")


#Virtual
func _on_field_ready() -> void:
	pass


#Virtual Default
func on_interfield_drag_started() -> void:
	hide()


#Virtual Default
func on_interfield_drag_stopped() -> void:
	raise()
	show()


#Virtual
func get_drag_graphic() -> Node2D:
	return null


#Virtual default
func _on_hover(point: Vector2, initial: bool, grabbed_object: Node2D) -> void:
	for mode in _modes.get_active_modes():
		mode._on_hover(point, initial, grabbed_object)


#Virtual default
func _on_unhover() -> void:
	for mode in _modes.get_active_modes():
		mode._on_unhover()


#Virtual default
func _on_press(point: Vector2) -> void:
	for mode in _modes.get_active_modes():
		if _current_event.is_active():
			mode._on_press(point)


#Virtual default
func _on_drag(point: Vector2, change: Vector2) -> void:
	for mode in _modes.get_active_modes():
		if _current_event.is_active():
			mode._on_drag(point, change)


#Virtual default
func _on_drop(point: Vector2) -> void:
	for mode in _modes.get_active_modes():
		if _current_event.is_active():
			mode._on_drop(point)


func get_object_type() -> int:
	var object_to_group_map = field.get_globals().OBJECT_TO_GROUP_MAP
	for object_type in object_to_group_map:
		if is_in_group(object_to_group_map[object_type]):
			return object_type
	return GameGlobals.NO_OBJECT


func update_active_modes(_new_tool:="") -> void:
	var object_type = get_object_type()
	var active_modes = field.get_active_modes_for_object(object_type)
	_modes.set_by_list(active_modes)


func is_mode_active(mode: String) -> bool:
	return _modes.is_active(mode)
