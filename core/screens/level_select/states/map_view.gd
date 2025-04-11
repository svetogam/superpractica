# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	_target.current_map.hide_node_detail()
	_target.current_map.set_active_camera(TopicMap.TopicCamera.SCROLL)

	_target.current_map.camera_point.draggable = true
	_target.current_map.scroll_camera.position_smoothing_enabled = true
	_target.current_map.node_pressed.connect(_on_node_pressed)
	_target.back_button.pressed.connect(_on_back_button_pressed)

	_target.set_overlay(_target.current_map.topic_data)


func _on_node_pressed(node: Control) -> void:
	if node is SubtopicNode:
		_target.use_new_viewport(_target.ViewportPlace.INNER)
		_target.add_topic_map(node.topic_data, _target.ViewportPlace.INNER)
		_target.inner_map.set_active_camera(TopicMap.TopicCamera.SURVEY)
		_target.current_map.show_node_detail(node.id, _target.inner_viewport)
	elif node is LevelNode:
		_target.current_map.show_node_detail(node.id, _target.level_viewport)

	_change_state("InFromMapToNode")


func _on_back_button_pressed() -> void:
	_change_state("OutFromMapToNode")


func _exit(_next_state: String) -> void:
	_target.current_map.camera_point.draggable = false
	_target.current_map.scroll_camera.position_smoothing_enabled = false
	_target.current_map.node_pressed.disconnect(_on_node_pressed)
	_target.back_button.pressed.disconnect(_on_back_button_pressed)
