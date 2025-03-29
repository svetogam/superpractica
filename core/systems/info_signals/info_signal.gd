# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name InfoSignal
extends Node2D

@onready var anim_player := %BaseAnimationPlayer as AnimationPlayer


func erase(animation := "out_fade") -> void:
	anim_player.play(animation)
	anim_player.animation_finished.connect(_on_exit_animation_finished)


func _on_exit_animation_finished(_animation: StringName) -> void:
	queue_free()
