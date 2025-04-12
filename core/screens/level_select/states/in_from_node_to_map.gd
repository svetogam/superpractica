# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	if _target.outer_viewport != null:
		_target.disuse_viewport(_target.ViewportPlace.OUTER)

	_target.inner_map.set_camera_point_to_origin()
	_target.current_map.transition_to_camera(
		TopicMap.TopicCamera.THUMBNAIL,
		_on_zoom_finished
	)
	_target.inner_map.transition_to_camera(TopicMap.TopicCamera.SCROLL)


func _on_zoom_finished() -> void:
	_target.shift_viewports_out()

	_target.zoomed_in.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	pass
