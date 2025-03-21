# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

class_name Animator2D
extends Node

signal move_completed
signal growth_completed

const DEFAULT_MOVE_TIME := 1.0
const DEFAULT_GROWTH_TIME := 1.0
var _target: Node2D


func _enter_tree() -> void:
	_target = get_parent()
	assert(_target != null)


func move_to_position(destination: Vector2, move_time := DEFAULT_MOVE_TIME) -> void:
	move_time = move_time * Game.get_animation_time_modifier()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(_target, "position", destination, move_time)
	tween.tween_callback(move_completed.emit)


func move_to_proportional_position(pos: Vector2, move_time := DEFAULT_MOVE_TIME) -> void:
	var destination := _get_position_in_screen(pos)
	move_to_position(destination, move_time)


func grow_to_ratio(size_ratio: float, growth_time := DEFAULT_GROWTH_TIME) -> void:
	growth_time = growth_time * Game.get_animation_time_modifier()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(_target, "scale", Vector2(size_ratio, size_ratio), growth_time)
	tween.tween_callback(growth_completed.emit)


func delete_after_delay(delay: float) -> void:
	var timer := get_tree().create_timer(delay)
	timer.timeout.connect(_target.queue_free)


func _get_position_in_screen(position: Vector2) -> Vector2:
	assert(position.x >= 0 and position.x <= 1)
	assert(position.y >= 0 and position.y <= 1)
	var screen_rect := Game.get_screen_rect()
	return Vector2(screen_rect.size.x * position.x, screen_rect.size.y * position.y)
