# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicNode
extends Control

var id: String
var _thumbnail_camera: Camera2D
@onready var main_button := %MainButton as Button


func _enter_tree() -> void:
	CSLocator.with(self).connect_service_found(
			Game.SERVICE_THUMBNAIL_CAMERA, _on_thumbnail_camera_found)


func _on_thumbnail_camera_found(p_thumbnail_camera: Camera2D) -> void:
	_thumbnail_camera = p_thumbnail_camera


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
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(%Mask, "modulate:a", 0.0, duration)
		tween.parallel().tween_property(%Detail, "modulate:a", 1.0, duration)

	%Thumbnail.texture = thumbnail_viewport.get_texture()
	_update_thumbnail_camera.call_deferred.call_deferred()


func _update_thumbnail_camera() -> void:
	var level_texture_rect = %Thumbnail.get_global_rect()
	_thumbnail_camera.global_position = level_texture_rect.get_center()
	_thumbnail_camera.zoom = Vector2(
		get_viewport().get_visible_rect().size.x / level_texture_rect.size.x,
		get_viewport().get_visible_rect().size.y / level_texture_rect.size.y
	)
