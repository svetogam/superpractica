# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	_target.current_map.focused_node = null

	_target.current_map.set_active_camera(TopicMap.TopicCamera.SCROLL)
	_target.set_overlay(_target.current_map.topic_data)

	_target.current_map.camera_point.draggable = true
	_target.current_map.camera_point.force_stop_dragging()
	_target.current_map.scroll_camera.position_smoothing_enabled = true
	_target.current_map.node_pressed.connect(_on_node_pressed)
	_target.back_button.pressed.connect(_on_back_button_pressed)

	for node in _target.current_map.get_topic_nodes():
		if node.main_button.is_hovered():
			node.pop()
		node.main_button.mouse_entered.connect(node.pop)
		node.main_button.mouse_exited.connect(node.unpop)

	# Prepare outer topic-map if necessary
	var topic_data = _target.current_map.topic_data
	if _target.outer_viewport == null and topic_data.supertopic != null:
		_target.use_new_viewport(_target.ViewportPlace.OUTER)
		_target.add_topic_map(topic_data.supertopic, _target.ViewportPlace.OUTER)
		_target.outer_map.set_active_camera(TopicMap.TopicCamera.THUMBNAIL)
		_target.outer_map.focus_on_node(topic_data.id)
		_target.outer_map.focused_node.view_detail(_target.current_viewport)


func _on_node_pressed(node: TopicNode) -> void:
	if node is LevelNode:
		Game.request_load_level.emit(node.level_data)
	_target.current_map.focus_on_node(node.id)

	_change_state("InFromMapToNode")


func _on_back_button_pressed() -> void:
	_change_state("OutFromMapToNode")


func _exit(_next_state: String) -> void:
	_target.current_map.camera_point.draggable = false
	_target.current_map.scroll_camera.position_smoothing_enabled = false
	_target.current_map.node_pressed.disconnect(_on_node_pressed)
	_target.back_button.pressed.disconnect(_on_back_button_pressed)

	for node in _target.current_map.get_topic_nodes():
		node.unpop()
		node.main_button.mouse_entered.disconnect(node.pop)
		node.main_button.mouse_exited.disconnect(node.unpop)
