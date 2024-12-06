#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name ScreenEffect
extends Node2D

@onready var animator := $Animator as Animator2D
@onready var _animation_player := $AnimationPlayer as AnimationPlayer


# Virtual
func set_by_effect(_original: ScreenEffect) -> void:
	pass


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


# Unused
func reparent_from_sub_to_root_group(root_group: ScreenEffectGroup) -> void:
	var local_effect_layer = get_canvas_layer_node()
	var root_effect_layer = root_group.get_canvas_layer_node()
	Utils.reparent_out_of_sub_viewport(self, root_group)
	global_position += root_effect_layer.offset - local_effect_layer.offset
