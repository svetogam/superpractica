# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const ZOOM_DURATION := 0.45


func _enter(_last_state: String) -> void:
	_target.zooming_started.emit()

	if _target.outer_viewport != null:
		_target.disuse_viewport(_target.ViewportPlace.OUTER)

	_target.inner_map.set_camera_point_to_origin()
	_target.current_map.update_thumbnail_camera()
	_target.current_map.transition_camera.duration = ZOOM_DURATION
	_target.current_map.transition_camera.position_ease = Tween.EASE_OUT
	_target.current_map.transition_camera.transition(
		_target.current_map.thumbnail_camera,
		_on_zoom_finished
	)
	_target.inner_map.transition_camera.duration = ZOOM_DURATION
	_target.inner_map.transition_camera.position_ease = Tween.EASE_IN_OUT
	_target.inner_map.transition_camera.transition(_target.inner_map.scroll_camera)


func _on_zoom_finished() -> void:
	_target.shift_viewports_out()

	_change_state("MapView")


func _exit(_next_state: String) -> void:
	_target.zooming_stopped.emit()
