# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

extends Node2D

@export var draggable := true
@export var blockable := true
@export var keep_in_bounds := false
@export var bounds := Rect2()
@export var drag_speed := 1.0
var _dragging := false


func _process(_delta: float) -> void:
	if draggable and keep_in_bounds:
		clamp_in_bounds()


func _input(event: InputEvent) -> void:
	if draggable:
		if event is InputEventMouseButton:
			if event.is_action_pressed("primary_mouse") and not blockable:
				_dragging = true
			if event.is_action_released("primary_mouse"):
				_dragging = false

		if _dragging and event is InputEventMouseMotion:
			position -= event.relative * drag_speed


func _unhandled_input(event: InputEvent) -> void:
	# Drag by unhandled input instead if blockable
	if (blockable and event is InputEventMouseButton
			and event.is_action_pressed("primary_mouse")):
		_dragging = true


func clamp_in_bounds() -> void:
	position = position.clamp(bounds.position, bounds.end)
