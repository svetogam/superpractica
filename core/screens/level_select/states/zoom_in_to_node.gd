# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.get_current_topic_map()


func _enter(_last_state: String) -> void:
	assert(_map.focused_node != null)

	# Start zoom animation
	var new_position = _map.focused_node.get_rect().get_center()
	(create_tween().set_trans(Tween.TRANS_QUART)
			.set_ease(Tween.EASE_OUT)
			.tween_property(
			_target.camera_point, "position", new_position, _target.ZOOM_IN_DURATION))

	var tween := (create_tween().set_trans(Tween.TRANS_QUAD)
			.set_ease(Tween.EASE_IN_OUT)
			.tween_property(
			_target.player_camera, "zoom", _target.NODE_ZOOM, _target.ZOOM_IN_DURATION))
	tween.finished.connect(_on_zoom_finished)


func _on_zoom_finished() -> void:
	_target.zoomed_in.emit()
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	pass
