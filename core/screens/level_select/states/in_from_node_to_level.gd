# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	assert(_target.current_map.focused_node is LevelNode)

	_target.current_map.transition_to_camera(
		TopicMap.TopicCamera.THUMBNAIL,
		_on_zoom_finished
	)


func _on_zoom_finished() -> void:
	assert(_target.current_map.focused_node.level_data != null)

	_target.zoomed_in.emit()
	_target.level_entered.emit(_target.current_map.focused_node.level_data)


func _exit(_next_state: String) -> void:
	pass
