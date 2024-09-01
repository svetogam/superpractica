#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name ScreenEffectGroup
extends Node2D


func _init(effect_layer: CanvasLayer) -> void:
	effect_layer.add_child(self)


func create_effect(effect_scene: PackedScene, pos: Vector2) -> ScreenEffect:
	var effect := effect_scene.instantiate()
	_add_effect(effect)
	effect.position = pos
	return effect


func _add_effect(effect: ScreenEffect) -> void:
	add_child(effect)


func clear() -> void:
	for child in get_effects():
		child.free()


func get_effects() -> Array:
	return get_children()
