# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	assert(_target.current_map.focused_node != null)

	_target.current_map.set_active_camera(TopicMap.TopicCamera.FOCUS)
	_target.set_overlay(_target.current_map.topic_data)

	_target.current_map.focused_node.overview_button.pressed.connect(_on_node_pressed)
	_target.back_button.pressed.connect(_on_back_button_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("primary_mouse"):
		_change_state("OutFromNodeToMap")


func _on_node_pressed() -> void:
	if _target.current_map.focused_node is LevelNode:
		_change_state("InFromNodeToLevel")
	elif _target.current_map.focused_node is SubtopicNode:
		_change_state("InFromNodeToMap")
	else:
		assert(false)


func _on_back_button_pressed() -> void:
	_change_state("OutFromNodeToMap")


func _exit(_next_state: String) -> void:
	_target.current_map.focused_node.overview_button.pressed.disconnect(_on_node_pressed)
	_target.back_button.pressed.disconnect(_on_back_button_pressed)
