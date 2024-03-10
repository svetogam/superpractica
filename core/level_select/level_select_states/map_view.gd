#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends State

var _map: TopicMap:
	get:
		return _target.get_current_topic_map()
var _dragging := false


func _enter(_last_state: String) -> void:
	_map.hide_node_detail()
	_target.player_camera.zoom = _target.MAP_ZOOM
	_target.player_camera.position_smoothing_enabled = true

	_map.node_pressed.connect(_on_node_pressed)
	_target.back_button.pressed.connect(_on_back_button_pressed)

	# Update overlay
	if _target.has_containing_topic():
		_target.set_overlay(_map.topic_data.title, _map.topic_data.supertopic.title)
	else:
		_target.set_overlay(_map.topic_data.title)


func _process(_delta: float) -> void:
	# Keep camera in bounds
	var camera_limit_rect = _target.get_camera_limit_rect()
	_target.camera_point.position = _target.camera_point.position.clamp(
			camera_limit_rect.position, camera_limit_rect.end)


func _input(event: InputEvent) -> void:
	# Drag camera
	if event is InputEventMouseButton:
		if event.is_action_pressed("primary_mouse"):
			_dragging = true
		if event.is_action_released("primary_mouse"):
			_dragging = false

	if _dragging and event is InputEventMouseMotion:
		_target.camera_point.position -= event.relative * _target.ZOOM_SCALE


func _on_node_pressed(node: Control) -> void:
	# Set up subtopic map
	if node is SubtopicNode:
		_target.stage_topic_map(node.topic_data)

	_map.show_node_detail(node.id, _target.staging_viewport.get_texture())
	_target.player_camera.position_smoothing_enabled = false

	_change_state("ZoomInToNode")


func _on_back_button_pressed() -> void:
	assert(_target.has_containing_topic())
	_change_state("ZoomOutToTopic")


func _exit(_next_state: String) -> void:
	_map.node_pressed.disconnect(_on_node_pressed)
	_target.back_button.pressed.disconnect(_on_back_button_pressed)
