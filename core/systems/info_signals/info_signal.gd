# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name InfoSignal
extends Node2D

var _erasing := false
@onready var anim_player := %BaseAnimationPlayer as AnimationPlayer


func erase(animation := "out_fade") -> void:
	if not _erasing:
		_erasing = true
		anim_player.play(animation)
		anim_player.animation_finished.connect(_on_exit_animation_finished)


func _on_exit_animation_finished(_animation: StringName) -> void:
	queue_free()


# Virtual
func get_base_size() -> Vector2:
	assert(false)
	return Vector2(0, 0)


func get_size() -> Vector2:
	var base_size = get_base_size()
	return Vector2(base_size.x * scale.x, base_size.y * scale.y)
