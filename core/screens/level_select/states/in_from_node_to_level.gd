# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const ZOOM_DURATION := 0.45


func _enter(_last_state: String) -> void:
	assert(_target.current_map.focused_node is LevelNode)

	_target.zooming_started.emit()

	_target.current_map.update_thumbnail_camera()
	_target.current_map.transition_camera.duration = ZOOM_DURATION
	_target.current_map.transition_camera.position_ease = Tween.EASE_OUT
	_target.current_map.transition_camera.transition(
		_target.current_map.thumbnail_camera,
		_on_zoom_finished
	)


func _on_zoom_finished() -> void:
	assert(_target.current_map.focused_level != null)

	Game.request_enter_level.emit(_target.current_map.focused_level)


func _exit(_next_state: String) -> void:
	_target.zooming_stopped.emit()
