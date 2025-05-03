# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const SUBTOPIC_ZOOM_DURATION := 0.45
const LEVEL_ZOOM_DURATION := 0.50


func _enter(_last_state: String) -> void:
	_target.zooming_started.emit()
	_target.overlay.system_button.disabled = true
	_target.overlay.slide_back_button_out()

	var focused_node = _target.current_map.focused_node
	var next_camera: Camera2D
	if focused_node is SubtopicNode:
		_target.use_new_viewport(_target.ViewportPlace.INNER)
		_target.add_topic_map(focused_node.topic_data, _target.ViewportPlace.INNER)
		_target.inner_map.set_active_camera(TopicMap.TopicCamera.SURVEY)
		focused_node.view_detail(_target.inner_viewport, SUBTOPIC_ZOOM_DURATION)
		_target.current_map.transition_camera.duration = SUBTOPIC_ZOOM_DURATION
		next_camera = _target.current_map.subtopic_focus_camera
	elif focused_node is LevelNode:
		# Wait a little as level loads to reduce stuttering
		await get_tree().process_frame
		await get_tree().process_frame

		focused_node.view_detail(_target.level_viewport, LEVEL_ZOOM_DURATION)
		_target.current_map.transition_camera.duration = LEVEL_ZOOM_DURATION
		next_camera = _target.current_map.level_focus_camera
	else:
		assert(false)
	_target.current_map.transition_camera.position_ease = Tween.EASE_OUT
	_target.current_map.transition_camera.transition(
		next_camera,
		_on_zoom_finished
	)


func _on_zoom_finished() -> void:
	_change_state("NodeView")


func _exit(_next_state: String) -> void:
	_target.zooming_stopped.emit()
