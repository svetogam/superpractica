# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicNode
extends Node2D

const POP_DURATION := 0.2
const EXPANDED_SCALE := Vector2(1.1, 1.1)
var id: String
var _popping := false
var _fading_thumbnail := false
@onready var box := %Box as Control
@onready var main_button := %MainButton as BaseButton


func _ready() -> void:
	view_mask()


func view_mask(duration := 0.0) -> void:
	if duration <= 0.0:
		%Mask.modulate.a = 1.0
		%Detail.modulate.a = 0.0
	else:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(%Mask, "modulate:a", 1.0, duration)
		tween.parallel().tween_property(%Detail, "modulate:a", 0.0, duration)


func view_detail(thumbnail_viewport: SubViewport, duration := 0.0) -> void:
	if duration <= 0.0:
		%Mask.modulate.a = 0.0
		%Detail.modulate.a = 1.0
	else:
		# Fade in detail
		var tween_1 = create_tween()
		tween_1.set_trans(Tween.TRANS_QUAD)
		tween_1.set_ease(Tween.EASE_OUT)
		tween_1.tween_property(%Detail, "modulate:a", 1.0, duration)

		# Fade out mask more quickly
		var tween_2 = create_tween()
		tween_2.set_trans(Tween.TRANS_QUAD)
		tween_2.set_ease(Tween.EASE_OUT)
		tween_2.tween_property(%Mask, "modulate:a", 0.0, duration * 0.5)

	%Thumbnail.texture = thumbnail_viewport.get_texture()


func pop() -> void:
	if not _popping:
		_popping = true
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", EXPANDED_SCALE, POP_DURATION)


func unpop() -> void:
	if _popping:
		_popping = false
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector2.ONE, POP_DURATION)


func fade_thumbnail() -> void:
	if not _fading_thumbnail:
		_fading_thumbnail = true
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(%Thumbnail, "modulate:a", 0.5, POP_DURATION)


func unfade_thumbnail() -> void:
	if _fading_thumbnail:
		_fading_thumbnail = false
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(%Thumbnail, "modulate:a", 1.0, POP_DURATION)


func get_thumbnail_rect() -> Rect2:
	return %Thumbnail.get_global_rect()
