#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

## [FieldObject]s are the interactible things on [Field]s.
## Each represents a group of affordances and signifiers.
##
## Whether a [FieldObject] will accept an input or not depends on the
## combination of its active modes and the [Field]'s current tool.
## Tools map onto some combination of active modes for every [FieldObject].
## Inputs first call [FieldObject] hooks and then those same hooks in the
## [FieldObject]'s active [FieldObjectMode]s.
## [br][br]
## [b]Dragging[/b]
## [br]
## [b]1.[/b] It all begins in [method _pressed].
## There are 3 options to modify how inputs are processed:
## [br]
## [b]1a.[/b] If [method grab] is not called, then [method _released] will be called after
## input is released.
## This will be called whether the release input is above the [FieldObject] or not.
## [br]
## [b]1b.[/b] If [code]grab(false)[/code] is called, this will begin "internal grab".
## [br]
## [b]1c.[/b] If [code]grab(true)[/code] is called, this will begin "external grab".
## [br]
## [b]2.[/b] If either grab is started, then [method _dragged] will be called on all
## movements and [method _dropped] will be called instead of [method _released]
## on release.
## [method _received] will also be called on the object that the grabbed object
## is dropped onto, with the grabbed object as an argument.
## [br]
## [b]3.[/b] External drag makes it possible for the grabbed object to exit its original
## [Field].
## If it is dropped outside of its original Field, then [method _dropped_out]
## will be called instead of [method _dropped].
## If it is dropped onto a different [Field], then in addition to calling
## [method _dropped_out], [method Field._received_in] will be called on the
## receiving [Field], with the dragged object's [member object_data] as an argument.

class_name FieldObject
extends Area2D

enum _States {
	NONE,
	PRESSED,
	INTERNAL_GRABBED,
	EXTERNAL_GRABBED,
}

var field: Field
var object_type: int:
	get = _get_object_type
var object_data: FieldObjectData:
	get:
		return field.interface_data.object_data[object_type]
var _state: _States = _States.NONE
@onready var _modes := $ActiveModes as ModeGroup


# Virtual
static func _get_object_type() -> int:
	return Game.NO_OBJECT


func _ready() -> void:
	CSLocator.with(self).connect_service_found(Game.SERVICE_FIELD, _on_field_found)


func disable_input(disable := true) -> void:
	set_process_input(not disable)
	input_pickable = not disable


func _on_field_found(p_field: Field) -> void:
	field = p_field
	field.tool_changed.connect(update_active_modes)
	update_active_modes()


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


func _mouse_enter() -> void:
	_hovered(is_grabbed_externally(), field.dragged_object)
	for mode in _modes.get_active_modes():
		mode._hovered(is_grabbed_externally(), field.dragged_object)


func _mouse_exit() -> void:
	_unhovered(is_grabbed_externally(), field.dragged_object)
	for mode in _modes.get_active_modes():
		mode._unhovered(is_grabbed_externally(), field.dragged_object)


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("primary_mouse"):
		_state = _States.PRESSED
		_pressed(event.position)
		for mode in _modes.get_active_modes():
			mode._pressed(event.position)

	elif (event.is_action_released("primary_mouse") and not is_pressed()
			and field.dragged_object != null
			and field.dragged_object.get_instance_id() != get_instance_id()):
		_received(field.dragged_object.is_grabbed_externally(),
				field.dragged_object, event.position)
		for mode in _modes.get_active_modes():
			mode._received(field.dragged_object.is_grabbed_externally(),
					field.dragged_object, event.position)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_grabbed():
		_dragged(is_grabbed_externally(), event.position, event.relative)
		for mode in _modes.get_active_modes():
			mode._dragged(is_grabbed_externally(), event.position, event.relative)

	elif event.is_action_released("primary_mouse"):
		if is_pressed():
			_state = _States.NONE
			_released(event.position)
			for mode in _modes.get_active_modes():
				mode._released(event.position)
		elif is_grabbed_internally():
			_dropped(false, event.position)
			for mode in _modes.get_active_modes():
				mode._dropped(false, event.position)
			field.end_drag()
			end_grab()


func grab(external: bool) -> void:
	if external:
		_state = _States.EXTERNAL_GRABBED
		field.drag_object(self, true)
		hide()
	else:
		_state = _States.INTERNAL_GRABBED
		field.drag_object(self, false)
	get_viewport().set_input_as_handled()


func end_external_drag(outgoing: bool, point: Vector2, destination: Field = null) -> void:
	move_to_front()
	show()
	if outgoing:
		_dropped_out(destination)
		for mode in _modes.get_active_modes():
			mode._dropped_out(destination)
	else:
		_dropped(true, point)
		for mode in _modes.get_active_modes():
			mode._dropped(true, point)
	end_grab()


func end_grab() -> void:
	# Defer so that input-processing order does not matter
	set_deferred("_state", _States.NONE)


func is_pressed() -> bool:
	return _state == _States.PRESSED


func is_grabbed() -> bool:
	return _state == _States.INTERNAL_GRABBED or _state == _States.EXTERNAL_GRABBED


func is_grabbed_internally() -> bool:
	return _state == _States.INTERNAL_GRABBED


func is_grabbed_externally() -> bool:
	return _state == _States.EXTERNAL_GRABBED


func update_active_modes(_new_tool := Game.NO_TOOL) -> void:
	var active_modes := field.get_active_modes_for_object(object_type)
	_modes.set_by_list(active_modes)


func is_mode_active(mode: String) -> bool:
	return _modes.is_active(mode)
