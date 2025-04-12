# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	_target.current_map.transition_to_camera(
		TopicMap.TopicCamera.SURVEY,
		_on_zoom_finished
	)
	_target.outer_map.transition_to_camera(TopicMap.TopicCamera.FOCUS)
	_target.shift_viewports_in()


func _on_zoom_finished() -> void:
	_target.zoomed_out.emit()
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	pass
