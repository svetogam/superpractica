# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	_target.current_map.set_active_camera(TopicMap.TopicCamera.THUMBNAIL)
	_target.set_overlay(_target.current_map.topic_data)

	_target.current_map.transition_to_camera(
		TopicMap.TopicCamera.SCROLL,
		_on_zoom_finished
	)


func _on_zoom_finished() -> void:
	_target.level_undecided.emit()

	_target.zoomed_out.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	pass
