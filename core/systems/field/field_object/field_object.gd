# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

## [FieldObject]s are the interactible things on [Field]s.
## Each represents a group of affordances and signifiers.
##
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

var field: Field
var object_type: String:
	get = _get_object_type
var object_data: FieldObjectData:
	get:
		return field.interface_data.object_data[object_type]


# Virtual
static func _get_object_type() -> String:
	return Field.NO_OBJECT


func _ready() -> void:
	CSLocator.with(self).connect_service_found(Game.SERVICE_FIELD, _on_field_found)


func disable_input(disable := true) -> void:
	set_process_input(not disable)
	input_pickable = not disable


func _on_field_found(p_field: Field) -> void:
	field = p_field
	field.tool_changed.connect(_update_active_modes)
	_update_active_modes.call_deferred(field.tool_mode)


# Virtual
func _update_active_modes(_new_tool: String) -> void:
	pass


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


func _mouse_exit() -> void:
	_unhovered(is_grabbed_externally(), field.dragged_object)


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("primary_mouse"):
		$StateChart.send_event("press")
		_pressed(event.position)

		# Ensure initial call to _dragged()
		if is_grabbed():
			_dragged(is_grabbed_externally(), event.position, Vector2.ZERO)

	elif (
		event.is_action_released("primary_mouse")
		and not is_pressed()
		and field.dragged_object != null
		and field.dragged_object.get_instance_id() != get_instance_id()
	):
		_received(
			field.dragged_object.is_grabbed_externally(),
			field.dragged_object,
			event.position
		)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_grabbed():
		_dragged(is_grabbed_externally(), event.position, event.relative)

	elif event.is_action_released("primary_mouse"):
		if is_pressed():
			$StateChart.send_event("stop_press")
			_released(event.position)
		elif is_grabbed_internally():
			_dropped(false, event.position)
			field._end_drag()
			stop_grab()


func grab(external: bool) -> void:
	if external:
		$StateChart.send_event("grab_external")
		field._drag_object(self, true)
		hide()
	else:
		$StateChart.send_event("grab_internal")
		field._drag_object(self, false)
	get_viewport().set_input_as_handled()


func stop_grab() -> void:
	$StateChart.send_event("stop_grab")


func is_pressed() -> bool:
	return $StateChart/States/MouseInputState/Pressing.active


func is_grabbed() -> bool:
	return is_grabbed_internally() or is_grabbed_externally()


func is_grabbed_internally() -> bool:
	return $StateChart/States/MouseInputState/InternalDragging.active


func is_grabbed_externally() -> bool:
	return $StateChart/States/MouseInputState/ExternalDragging.active


func _end_external_drag(
	outgoing: bool, point: Vector2, destination: Field = null
) -> void:
	move_to_front()
	show()
	if outgoing:
		_dropped_out(destination)
	else:
		_dropped(true, point)
	stop_grab()
