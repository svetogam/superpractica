# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name ScreenEffectGroup
extends Node2D

const NEAR_OFFSET := Vector2(20, 15)
const DEFAULT_DELETE_DELAY := 1.0
const AffirmEffect := preload("uid://51v0feqeyjdr")
const RejectEffect := preload("uid://dmg7uc5b3wqhc")
const WarningEffect := preload("uid://dk3ojkrwuffyq")
const NumberEffectScene := preload("uid://cobbyy58sstrk")
var offset_source: CanvasItem


func _init(effect_layer: CanvasLayer, p_offset_source: CanvasItem = null) -> void:
	effect_layer.add_child(self)
	offset_source = p_offset_source


func create_effect(effect_scene: PackedScene, pos: Vector2) -> ScreenEffect:
	var effect := effect_scene.instantiate()
	add_child(effect)
	effect.position = pos
	if offset_source != null:
		effect.position += offset_source.global_position
	return effect


func affirm_or_else_reject(p_affirm: bool, pos: Vector2) -> ScreenEffect:
	if p_affirm:
		return affirm(pos)
	else:
		return reject(pos)


func affirm(pos: Vector2, deletion_delay := DEFAULT_DELETE_DELAY) -> ScreenEffect:
	var effect := create_effect(AffirmEffect, pos)
	effect.animator.delete_after_delay(deletion_delay)
	return effect


func reject(pos: Vector2, deletion_delay := DEFAULT_DELETE_DELAY) -> ScreenEffect:
	var effect := create_effect(RejectEffect, pos)
	effect.animator.delete_after_delay(deletion_delay)
	return effect


func warn(pos: Vector2) -> ScreenEffect:
	return create_effect(WarningEffect, pos + NEAR_OFFSET)


func give_number(number: int, pos: Vector2, animation := "rise") -> NumberEffect:
	var effect := create_effect(NumberEffectScene, pos)
	effect.number = number
	effect.animate(animation)
	return effect


func clear() -> void:
	for child in get_effects():
		child.free()


func get_effects() -> Array:
	return get_children()
