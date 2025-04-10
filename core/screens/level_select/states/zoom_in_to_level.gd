# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const ZOOM_DURATION := 0.5
var _map: TopicMap:
	get:
		return _target.current_map


func _enter(_last_state: String) -> void:
	assert(_map.focused_node is LevelNode)

	_map.transition_to_camera(_map.thumbnail_camera, ZOOM_DURATION, _on_zoom_finished)


func _on_zoom_finished() -> void:
	assert(_map.focused_node is LevelNode)
	assert(_map.focused_node.level_data != null)

	_target.zoomed_in.emit()
	_target.level_entered.emit(_map.focused_node.level_data)


func _exit(_next_state: String) -> void:
	pass
