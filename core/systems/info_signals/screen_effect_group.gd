# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ScreenEffectGroup
extends Node2D

var offset_source: CanvasItem


func _init(effect_layer: CanvasLayer, p_offset_source: CanvasItem = null) -> void:
	effect_layer.add_child(self)
	offset_source = p_offset_source


func create_effect(effect_scene: PackedScene, pos: Vector2) -> ScreenEffect:
	var effect := effect_scene.instantiate()
	_add_effect(effect)
	effect.position = pos
	if offset_source != null:
		effect.position += offset_source.global_position
	return effect


func _add_effect(effect: ScreenEffect) -> void:
	add_child(effect)


func clear() -> void:
	for child in get_effects():
		child.free()


func get_effects() -> Array:
	return get_children()
