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
extends Area2D

var field: Field:
	set = _do_not_set,
	get = _get_field
var object_type: int:
	set = _do_not_set,
	get = _get_object_type
var _pressing := false
@onready var _modes := $ActiveModes as ModeGroup


# Virtual
func _get_object_type() -> int:
	return GameGlobals.NO_OBJECT


# Virtual
func _on_field_ready() -> void:
	pass


# Virtual
func get_drag_graphic() -> ProceduralGraphic:
	return null


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


func _ready() -> void:
	update_active_modes()
	field.tool_changed.connect(update_active_modes)

	if field.is_ready():
		_on_field_ready()
	else:
		field.ready.connect(_on_field_ready)


func _mouse_enter() -> void:
	_hover(field.dragged_object)
	for mode in _modes.get_active_modes():
		mode._hover(field.dragged_object)


func _mouse_exit() -> void:
	_unhover()
	for mode in _modes.get_active_modes():
		mode._unhover()


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("primary_mouse"):
		_pressing = true
		_press(event.position)
		for mode in _modes.get_active_modes():
			mode._press(event.position)

	elif (event.is_action_released("primary_mouse") and not _pressing
			and field.dragged_object != null
			and field.dragged_object.get_instance_id() != get_instance_id()):
		_take_drop(field.dragged_object, event.position)
		for mode in _modes.get_active_modes():
			mode._take_drop(field.dragged_object, event.position)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and _pressing:
		_drag(event.position, event.relative)
		for mode in _modes.get_active_modes():
			mode._drag(event.position, event.relative)
	elif event.is_action_released("primary_mouse") and _pressing:
		if _pressing:
			_release(event.position)
			for mode in _modes.get_active_modes():
				mode._release(event.position)
		_pressing = false


func start_interfield_drag() -> void:
	hide()


func end_interfield_drag(point: Vector2) -> void:
	move_to_front()
	show()
	_drop(point)
	for mode in _modes.get_active_modes():
		mode._drop(point)


func update_active_modes(_new_tool := GameGlobals.NO_TOOL) -> void:
	var active_modes := field.get_active_modes_for_object(object_type)
	_modes.set_by_list(active_modes)


func is_mode_active(mode: String) -> bool:
	return _modes.is_active(mode)


func _get_field() -> Field:
	var found = ContextUtils.get_parent_in_group(self, "fields")
	assert(found != null)
	return found


static func _do_not_set(_value: Variant) -> void:
	assert(false)


#======================================
# Delete these with later redesign
#======================================

var _position_before_grab: Vector2

func start_grab() -> void:
	_position_before_grab = position


func revert_drag() -> void:
	position = _position_before_grab


func get_total_drag_vector() -> Vector2:
	return position - _position_before_grab
