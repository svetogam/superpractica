# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.current_map


func _enter(_last_state: String) -> void:
	# Save current topic before changing it
	var contained_topic := _map.topic_data

	# Add containing viewport if not already added
	if _target.outer_viewport == null:
		_target.use_new_viewport(_target.ViewportPlace.OUTER)
		_target.add_topic_map(contained_topic.supertopic, _target.ViewportPlace.OUTER)

	# Enter new topic
	_target.shift_viewports_in()
	_target.inner_map.set_active_camera(_target.inner_map.survey_camera)
	_target.current_map.camera_point.position = _target.current_map.get_topic_node_center(
			contained_topic.id)

	# Update overlay
	if _map.topic_data.supertopic != null:
		_target.set_overlay(_map.topic_data.title, _map.topic_data.supertopic.title)
	else:
		_target.set_overlay(_map.topic_data.title)

	_map.show_node_detail(contained_topic.id, _target.inner_viewport.get_texture())
	_target.inner_map.camera_point.position = _target.inner_map.get_origin()

	_on_zoom_finished()


func _on_zoom_finished() -> void:
	_target.zoomed_out.emit()
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	pass
