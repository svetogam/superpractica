# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.get_current_topic_map()


func _enter(_last_state: String) -> void:
	assert(_target.has_containing_topic() != null)

	# Save current topic before changing it
	var contained_topic := _map.topic_data

	# Enter new topic
	_target.enter_containing_map(contained_topic.id)

	# Update overlay
	if _target.has_containing_topic():
		_target.set_overlay(_map.topic_data.title, _map.topic_data.supertopic.title)
	else:
		_target.set_overlay(_map.topic_data.title)

	_map.show_node_detail(contained_topic.id, _target.staging_viewport.get_texture())
	_target.player_camera.position_smoothing_enabled = false

	_on_zoom_finished()


func _on_zoom_finished() -> void:
	_target.zoomed_out.emit()
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	pass
