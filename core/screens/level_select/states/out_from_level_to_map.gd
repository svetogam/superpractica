# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const ZOOM_DURATION := 0.45


func _enter(_last_state: String) -> void:
	_target.zooming_started.emit()
	_target.overlay.system_button.disabled = true
	_target.overlay.slide_title_out(0.0)
	_target.overlay.slide_back_button_out(0.0)

	_target.current_map.focused_node.view_mask(ZOOM_DURATION)
	_target.current_map.set_active_camera(TopicMap.TopicCamera.THUMBNAIL)
	_target.overlay.set_topic(_target.current_map.topic_data)

	_target.current_map.update_thumbnail_camera()
	_target.current_map.transition_camera.duration = ZOOM_DURATION
	_target.current_map.transition_camera.position_ease = Tween.EASE_OUT
	_target.current_map.transition_camera.transition(
		_target.current_map.scroll_camera,
		_on_zoom_finished
	)


func _on_zoom_finished() -> void:
	Game.request_unload_level.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	_target.zooming_stopped.emit()
