# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var focused_node: TopicNode:
	get:
		return _target.current_map.focused_node


func _enter(_last_state: String) -> void:
	if focused_node is SubtopicNode:
		_target.current_map.set_active_camera(TopicMap.TopicCamera.SUBTOPIC_FOCUS)
	elif focused_node is LevelNode:
		_target.current_map.set_active_camera(TopicMap.TopicCamera.LEVEL_FOCUS)
	else:
		assert(false)

	_target.overlay.set_topic(_target.current_map.topic_data)
	_target.overlay.system_button.disabled = false
	_target.overlay.slide_title_in()

	_target.current_map.node_pressed.connect(_on_node_pressed)
	_target.overlay.back_button.pressed.connect(_on_back_button_pressed)

	if not focused_node.main_button.is_hovered():
		focused_node.fade_thumbnail()
	focused_node.main_button.mouse_entered.connect(focused_node.unfade_thumbnail)
	focused_node.main_button.mouse_exited.connect(focused_node.fade_thumbnail)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("primary_mouse"):
		_change_state("OutFromNodeToMap")


func _on_node_pressed(node: TopicNode) -> void:
	if node is LevelNode:
		_change_state("InFromNodeToLevel")
	elif node is SubtopicNode:
		_change_state("InFromNodeToMap")
	else:
		assert(false)


func _on_back_button_pressed() -> void:
	_change_state("OutFromNodeToMap")


func _exit(_next_state: String) -> void:
	_target.current_map.node_pressed.disconnect(_on_node_pressed)
	_target.overlay.back_button.pressed.disconnect(_on_back_button_pressed)

	focused_node.unfade_thumbnail()
	focused_node.main_button.mouse_entered.disconnect(focused_node.unfade_thumbnail)
	focused_node.main_button.mouse_exited.disconnect(focused_node.fade_thumbnail)
