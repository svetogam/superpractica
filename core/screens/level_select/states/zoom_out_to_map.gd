# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const ZOOM_DURATION := 0.35
var _map: TopicMap:
	get:
		return _target.current_map


func _enter(_last_state: String) -> void:
	assert(_map.focused_node != null)

	_map.camera_point.position = _map.get_topic_node_center(_map.focused_node.id)
	_map.transition_to_camera(_map.scroll_camera, ZOOM_DURATION, _on_zoom_finished)


func _on_zoom_finished() -> void:
	if _map.focused_node is SubtopicNode:
		_target.disuse_viewport(_target.ViewportPlace.INNER)

	_target.zoomed_out.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	pass
