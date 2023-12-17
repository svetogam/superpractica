#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

class_name Animator2D
extends Node

signal move_completed
signal growth_completed

const DEFAULT_MOVE_TIME := 1.0
const DEFAULT_GROWTH_TIME := 1.0
const DEFAULT_DELETE_DELAY := 1.0
var _target: Node2D


func _enter_tree() -> void:
	_target = get_parent()
	assert(_target != null)


func move_to_position(destination: Vector2, move_time := DEFAULT_MOVE_TIME) -> void:
	move_time = move_time * Game.get_animation_time_modifier()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(_target, "position", destination, move_time)
	tween.tween_callback(emit_signal.bind("move_completed"))


func move_to_proportional_position(pos: Vector2, move_time := DEFAULT_MOVE_TIME) -> void:
	var destination := _get_position_in_screen(pos)
	move_to_position(destination, move_time)


func grow_to_ratio(size_ratio: float, growth_time := DEFAULT_GROWTH_TIME) -> void:
	growth_time = growth_time * Game.get_animation_time_modifier()
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(_target, "scale", Vector2(size_ratio, size_ratio), growth_time)
	tween.tween_callback(emit_signal.bind("growth_completed"))


func delete_after_delay(delay := DEFAULT_DELETE_DELAY) -> void:
	var timer := get_tree().create_timer(delay)
	timer.timeout.connect(_target.queue_free)


func _get_position_in_screen(position: Vector2) -> Vector2:
	assert(position.x >= 0 and position.x <= 1)
	assert(position.y >= 0 and position.y <= 1)
	var root_viewport := get_tree().root.get_viewport()
	return Vector2(root_viewport.size.x * position.x, root_viewport.size.y * position.y)
