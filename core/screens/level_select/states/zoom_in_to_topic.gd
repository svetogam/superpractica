# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.current_topic_map


func _enter(_last_state: String) -> void:
	if _target.containing_viewport != null:
		_target.disuse_viewport(_target.containing_viewport)

	_target.make_viewport_containing(_target.current_viewport)
	_target.make_viewport_current(_target.staging_viewport)
	_target.current_topic_map.camera_point.position = Vector2.ZERO
	_target.set_overlay(_map.topic_data.title, _map.topic_data.supertopic.title)

	_on_zoom_finished()


func _on_zoom_finished() -> void:
	_target.zoomed_in.emit()
	_change_state("MapView")


func _exit(_next_state: String) -> void:
	pass
