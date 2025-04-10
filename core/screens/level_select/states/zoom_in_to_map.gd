# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const ZOOM_DURATION := 0.5
var _map: TopicMap:
	get:
		return _target.current_map


func _enter(_last_state: String) -> void:
	if _target.outer_viewport != null:
		_target.disuse_viewport(_target.ViewportPlace.OUTER)

	_map.transition_to_camera(_map.thumbnail_camera, ZOOM_DURATION, _on_zoom_finished)
	_target.inner_map.transition_to_camera(_target.inner_map.scroll_camera, ZOOM_DURATION)


func _on_zoom_finished() -> void:
	_target.shift_viewports_out()
	_target.current_map.camera_point.position = _target.current_map.get_origin()
	_target.set_overlay(_map.topic_data.title, _map.topic_data.supertopic.title)

	_target.zoomed_in.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	pass
