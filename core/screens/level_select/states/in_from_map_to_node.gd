# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	assert(_target.current_map.focused_node != null)

	_target.zooming_started.emit()

	_target.current_map.transition_to_camera(
		TopicMap.TopicCamera.FOCUS,
		_on_zoom_finished
	)


func _on_zoom_finished() -> void:
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	_target.zooming_stopped.emit()
