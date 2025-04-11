# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	# Save current topic before changing it
	var contained_topic = _target.current_map.topic_data

	# Add containing viewport if not already added
	if _target.outer_viewport == null:
		_target.use_new_viewport(_target.ViewportPlace.OUTER)
		_target.add_topic_map(contained_topic.supertopic, _target.ViewportPlace.OUTER)

	# Enter new topic
	_target.shift_viewports_in()
	_target.inner_map.set_active_camera(TopicMap.TopicCamera.SURVEY)
	_target.current_map.set_camera_point_to_node(contained_topic.id)

	_target.set_overlay(_target.current_map.topic_data)
	_target.current_map.show_node_detail(contained_topic.id, _target.inner_viewport)
	_target.inner_map.set_camera_point_to_origin()

	_on_zoom_finished()


func _on_zoom_finished() -> void:
	_target.zoomed_out.emit()
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	pass
