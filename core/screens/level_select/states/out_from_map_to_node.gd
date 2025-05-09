# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const ZOOM_DURATION := 0.3

func _enter(_last_state: String) -> void:
	_target.zooming_started.emit()
	_target.overlay.system_button.disabled = true
	_target.overlay.slide_title_out()
	_target.overlay.slide_back_button_out()

	_target.current_map.transition_camera.duration = ZOOM_DURATION
	_target.current_map.transition_camera.position_ease = Tween.EASE_IN_OUT
	_target.current_map.transition_camera.transition(
		_target.current_map.survey_camera,
		_on_zoom_finished
	)
	_target.outer_map.update_thumbnail_camera()
	_target.outer_map.transition_camera.duration = ZOOM_DURATION
	_target.outer_map.transition_camera.position_ease = Tween.EASE_OUT
	_target.outer_map.transition_camera.transition(
			_target.outer_map.subtopic_focus_camera)
	_target.shift_viewports_in()


func _on_zoom_finished() -> void:
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	_target.zooming_stopped.emit()
