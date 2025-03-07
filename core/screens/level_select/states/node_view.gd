# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var _map: TopicMap:
	get:
		return _target.get_current_topic_map()


func _enter(_last_state: String) -> void:
	assert(_map.focused_node != null)

	_map.focused_node.overview_button.pressed.connect(_on_node_pressed)
	_target.back_button.pressed.connect(_on_back_button_pressed)

	_target.player_camera.zoom = _target.NODE_ZOOM


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("primary_mouse"):
		_change_state("ZoomOutToMap")


func _on_node_pressed() -> void:
	assert(_map.focused_node != null)

	if _map.focused_node is LevelNode:
		assert(_map.focused_node.level_data != null)
		_target.level_entered.emit(_map.focused_node.level_data)
	elif _map.focused_node is SubtopicNode:
		_change_state("ZoomInToTopic")
	else:
		assert(false)


func _on_back_button_pressed() -> void:
	_change_state("ZoomOutToMap")


func _exit(_next_state: String) -> void:
	_map.focused_node.overview_button.pressed.disconnect(_on_node_pressed)
	_target.back_button.pressed.disconnect(_on_back_button_pressed)
