# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.current_map


func _enter(_last_state: String) -> void:
	assert(_map.focused_node != null)

	_map.focus_camera.position = _map.focused_node.get_rect().get_center()
	_map.set_active_camera(_map.focus_camera)

	_map.focused_node.overview_button.pressed.connect(_on_node_pressed)
	_target.back_button.pressed.connect(_on_back_button_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("primary_mouse"):
		_change_state("ZoomOutToMap")


func _on_node_pressed() -> void:
	assert(_map.focused_node != null)

	if _map.focused_node is LevelNode:
		_change_state("ZoomInToLevel")
	elif _map.focused_node is SubtopicNode:
		_change_state("ZoomInToTopic")
	else:
		assert(false)


func _on_back_button_pressed() -> void:
	_change_state("ZoomOutToMap")


func _exit(_next_state: String) -> void:
	_map.focused_node.overview_button.pressed.disconnect(_on_node_pressed)
	_target.back_button.pressed.disconnect(_on_back_button_pressed)
