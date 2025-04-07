# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.current_topic_map


func _enter(_last_state: String) -> void:
	assert(_map.focused_node != null)

	_map.focus_camera.position = _map.focused_node.get_rect().get_center()
	_map.transition_to_camera(
			_map.focus_camera, _target.ZOOM_IN_DURATION, _on_zoom_finished)


func _on_zoom_finished() -> void:
	_target.zoomed_in.emit()
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	pass
