# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ScreenEffect
extends Node2D

@onready var animator := $Animator as Animator2D
@onready var _animation_player := $AnimationPlayer as AnimationPlayer


func animate(animation: String) -> void:
	if animation == "bounce":
		_animation_player.play("popup_bounce_anim")
	elif animation == "shake":
		_animation_player.play("popup_shake_anim")
	elif animation == "rise":
		_animation_player.play("popup_rise_anim")
	elif animation == "descend":
		_animation_player.play("popup_descend_anim")
	elif animation == "fade_in":
		_animation_player.play("popup_fade_in_anim")
	elif animation == "grow":
		_animation_player.play("popup_grow_anim")
	_animation_player.advance(0)
