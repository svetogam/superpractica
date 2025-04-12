# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	assert(_target.current_map.focused_node != null)

	_target.current_map.set_camera_point_to_node(_target.current_map.focused_node.id)
	_target.current_map.transition_to_camera(
		TopicMap.TopicCamera.SCROLL,
		_on_zoom_finished
	)


func _on_zoom_finished() -> void:
	if _target.current_map.focused_node is SubtopicNode:
		_target.disuse_viewport(_target.ViewportPlace.INNER)

	_target.zoomed_out.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	pass
