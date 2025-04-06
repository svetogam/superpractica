# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.get_current_topic_map()


func _enter(_last_state: String) -> void:
	assert(_map.focused_node != null)

	%CameraPoint.position = _map.focused_node.get_rect().get_center()
	_target.transition_to_camera(
			%ScrollCamera, _target.ZOOM_OUT_DURATION, _on_zoom_finished)


func _on_zoom_finished() -> void:
	if _map.focused_node is SubtopicNode:
		_target.unstage_topic_map()

	_target.zoomed_out.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	pass
