# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name InfoSignal
extends Node2D
## Base class that info signals derive from.
##
## Info signals should extend this class and be created using [InfoSignaler]s.

var _erasing := false
## Use this to animate the signal.
@onready var anim_player := %BaseAnimationPlayer as AnimationPlayer


## Call this to smoothly erase and free this object.
## [br][br]
## [param animation] can be any animation from the info signal animation library.
## It should begin with [code]out_[/code].
func erase(animation := "out_fade") -> void:
	if not _erasing:
		_erasing = true
		anim_player.play(animation)
		anim_player.animation_finished.connect(_on_exit_animation_finished)


func _on_exit_animation_finished(_animation: StringName) -> void:
	queue_free()


# Virtual
## Override this to calculate the base size of the [InfoSignal] at regular scale.
## This is relevant for growing or shrinking the signal to fit into regions.
## [br][br]
## Calling this without overriding will crash on purpose.
func get_base_size() -> Vector2:
	assert(false)
	return Vector2.ZERO


## Returns the size calculated by [method get_base_size] with transformations applied.
func get_size() -> Vector2:
	var base_size = get_base_size()
	return Vector2(base_size.x * scale.x, base_size.y * scale.y)
