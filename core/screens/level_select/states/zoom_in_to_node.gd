# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const ZOOM_DURATION := 0.5
var _map: TopicMap:
	get:
		return _target.current_map


func _enter(_last_state: String) -> void:
	assert(_map.focused_node != null)

	_map.transition_to_camera(_map.focus_camera, ZOOM_DURATION, _on_zoom_finished)


func _on_zoom_finished() -> void:
	_target.zoomed_in.emit()
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	pass
