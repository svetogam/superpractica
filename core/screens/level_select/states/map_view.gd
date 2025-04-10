# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.current_map
var _dragging := false


func _enter(_last_state: String) -> void:
	_map.hide_node_detail()
	_map.set_active_camera(_map.scroll_camera)

	_map.scroll_camera.position_smoothing_enabled = true
	_map.node_pressed.connect(_on_node_pressed)
	_target.back_button.pressed.connect(_on_back_button_pressed)

	# Update overlay
	if _map.topic_data.supertopic != null:
		_target.set_overlay(_map.topic_data.title, _map.topic_data.supertopic.title)
	else:
		_target.set_overlay(_map.topic_data.title)


func _process(_delta: float) -> void:
	# Keep camera in bounds
	var camera_limit_rect = _map.get_camera_limit_rect()
	_map.camera_point.position = _map.camera_point.position.clamp(
			camera_limit_rect.position, camera_limit_rect.end)


func _input(event: InputEvent) -> void:
	# Drag camera
	if event is InputEventMouseButton:
		if event.is_action_pressed("primary_mouse"):
			_dragging = true
		if event.is_action_released("primary_mouse"):
			_dragging = false

	if _dragging and event is InputEventMouseMotion:
		_map.camera_point.position -= event.relative * TopicMap.ZOOM_SCALE


func _on_node_pressed(node: Control) -> void:
	# Set up subtopic map
	if node is SubtopicNode:
		_target.use_new_viewport(_target.ViewportPlace.INNER)
		_target.add_topic_map(node.topic_data, _target.ViewportPlace.INNER)
		_target.inner_map.set_active_camera(_target.inner_map.survey_camera)
		_map.show_node_detail(node.id, _target.inner_viewport.get_texture())
	elif node is LevelNode:
		_map.show_node_detail(node.id)

	_change_state("ZoomInToNode")


func _on_back_button_pressed() -> void:
	_change_state("ZoomOutToTopic")


func _exit(_next_state: String) -> void:
	_map.scroll_camera.position_smoothing_enabled = false
	_map.node_pressed.disconnect(_on_node_pressed)
	_target.back_button.pressed.disconnect(_on_back_button_pressed)
