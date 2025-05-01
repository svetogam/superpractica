# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const ZOOM_DURATION := 0.3


func _enter(_last_state: String) -> void:
	assert(_target.current_map.focused_node != null)

	_target.zooming_started.emit()
	_target.overlay.system_button.disabled = true

	_target.current_map.focused_node.view_mask(ZOOM_DURATION)
	_target.current_map.set_camera_point_to_node(_target.current_map.focused_node.id)
	_target.current_map.transition_camera.duration = ZOOM_DURATION
	_target.current_map.transition_camera.position_ease = Tween.EASE_OUT
	_target.current_map.transition_camera.transition(
		_target.current_map.scroll_camera,
		_on_zoom_finished
	)


func _on_zoom_finished() -> void:
	if _target.current_map.focused_node is SubtopicNode:
		_target.disuse_viewport(_target.ViewportPlace.INNER)
	elif _target.current_map.focused_node is LevelNode:
		Game.request_unload_level.emit()

	_change_state("MapView")


func _exit(_next_state: String) -> void:
	_target.zooming_stopped.emit()
