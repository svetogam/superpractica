# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.current_topic_map


func _enter(_last_state: String) -> void:
	# Save current topic before changing it
	var contained_topic := _map.topic_data

	# Add containing viewport if not already added
	if _target.containing_viewport == null:
		var viewport = _target.get_unused_viewport()
		_target.add_topic_map_to_viewport(contained_topic.supertopic, viewport)
		_target.make_viewport_containing(viewport)

	# Enter new topic
	_target.make_viewport_preview(_target.current_viewport)
	_target.make_viewport_current(_target.containing_viewport)
	_target.current_topic_map.focus_on_node_id(contained_topic.id)
	_target.containing_viewport = null

	# Update overlay
	if _target.has_containing_topic():
		_target.set_overlay(_map.topic_data.title, _map.topic_data.supertopic.title)
	else:
		_target.set_overlay(_map.topic_data.title)

	_map.show_node_detail(contained_topic.id, _target.staging_viewport.get_texture())
	_target.staged_topic_map.camera_point.position = Vector2.ZERO
	_map.scroll_camera.position_smoothing_enabled = false

	_on_zoom_finished()


func _on_zoom_finished() -> void:
	_target.zoomed_out.emit()
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	pass
