#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

class_name MouseInputSimulator
extends InputEventSimulator

var mouse_position := Vector2.ZERO


func set_initial_mouse_position(position: Vector2) -> void:
	mouse_position = position


func move_to(new_position: Vector2) -> void:
	var old_position := mouse_position
	var event := InputEventMouseMotion.new()
	event.position = new_position
	event.relative = new_position - old_position
	add_event(event)

	mouse_position = new_position


func move_by(change: Vector2) -> void:
	move_to(mouse_position + change)


func press_left() -> void:
	_press_button(MOUSE_BUTTON_LEFT)


func press_right() -> void:
	_press_button(MOUSE_BUTTON_RIGHT)


func press_middle() -> void:
	_press_button(MOUSE_BUTTON_MIDDLE)


func release_left() -> void:
	_release_button(MOUSE_BUTTON_LEFT)


func release_right() -> void:
	_release_button(MOUSE_BUTTON_RIGHT)


func release_middle() -> void:
	_release_button(MOUSE_BUTTON_MIDDLE)


func click_left(times:=1) -> void:
	_click_button(MOUSE_BUTTON_LEFT, times)


func click_right(times:=1) -> void:
	_click_button(MOUSE_BUTTON_RIGHT, times)


func click_middle(times:=1) -> void:
	_click_button(MOUSE_BUTTON_MIDDLE, times)


func click_left_at(position: Vector2, times:=1) -> void:
	_click_button_at(MOUSE_BUTTON_LEFT, position, times)


func click_right_at(position: Vector2, times:=1) -> void:
	_click_button_at(MOUSE_BUTTON_RIGHT, position, times)


func click_middle_at(position: Vector2, times:=1) -> void:
	_click_button_at(MOUSE_BUTTON_MIDDLE, position, times)


func drag_left_between(start_position: Vector2, end_position: Vector2) -> void:
	_drag_button_between(MOUSE_BUTTON_LEFT, start_position, end_position)


func drag_right_between(start_position: Vector2, end_position: Vector2) -> void:
	_drag_button_between(MOUSE_BUTTON_RIGHT, start_position, end_position)


func drag_middle_between(start_position: Vector2, end_position: Vector2) -> void:
	_drag_button_between(MOUSE_BUTTON_MIDDLE, start_position, end_position)


func drag_left_by(start_position: Vector2, change: Vector2) -> void:
	_drag_button_by(MOUSE_BUTTON_LEFT, start_position, change)


func drag_right_by(start_position: Vector2, change: Vector2) -> void:
	_drag_button_by(MOUSE_BUTTON_RIGHT, start_position, change)


func drag_middle_by(start_position: Vector2, change: Vector2) -> void:
	_drag_button_by(MOUSE_BUTTON_MIDDLE, start_position, change)


func _press_button(button: MouseButton) -> void:
	var event := InputEventMouseButton.new()
	event.position = mouse_position
	event.pressed = true
	event.button_index = button
	add_event(event)


func _release_button(button: MouseButton) -> void:
	var event := InputEventMouseButton.new()
	event.position = mouse_position
	event.pressed = false
	event.button_index = button
	add_event(event)


func _click_button(button: int, times: int = 1) -> void:
	for _i in range(times):
		_press_button(button)
		_release_button(button)


func _click_button_at(button: int, position: Vector2, times: int = 1) -> void:
	move_to(position)
	_click_button(button, times)


func _drag_button_between(button: int, start_position: Vector2, end_position: Vector2
) -> void:
	move_to(start_position)
	_press_button(button)
	move_to(end_position)
	_release_button(button)


func _drag_button_by(button: int, start_position: Vector2, change: Vector2) -> void:
	move_to(start_position)
	_press_button(button)
	move_to(start_position + change)
	_release_button(button)
