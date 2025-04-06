# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal exit_pressed
signal level_decided(level_data)
signal level_entered(level_data)
signal zoomed_in
signal zoomed_out

const ZOOM_SCALE := 10.0 # Should equal 1 / ScrollCamera.zoom
const ZOOM_IN_DURATION := 0.5
const ZOOM_OUT_DURATION := 0.35
const CAMERA_OVERSHOOT_MARGIN_RATIO := 0.25 * ZOOM_SCALE
const CAMERA_SURVEY_MARGIN := Vector2(80.0, 60.0) * ZOOM_SCALE
const TopicMapScene := preload("topic_map/topic_map.tscn")

var _staged_topic_map: TopicMap
var _current_topic_map: TopicMap
@onready var back_button := %BackButton as Button
@onready var staging_viewport := %StagingViewport as SubViewport


func _enter_tree() -> void:
	CSConnector.with(self).connect_setup("level_nodes", _setup_level_node)


func _ready() -> void:
	assert(Game.root_topic != null)

	if Game.current_level == null:
		stage_topic_map(Game.root_topic)
		enter_staged_map()
	else:
		enter_containing_map(Game.current_level.id)

	$StateMachine.activate()


func _setup_level_node(level_node: LevelNode) -> void:
	if not level_node.level_hinted.is_connected(level_decided.emit):
		level_node.level_hinted.connect(level_decided.emit)


func _on_menu_button_pressed() -> void:
	%MenuPopup.show()


func _on_continue_button_pressed() -> void:
	%MenuPopup.hide()


func _on_settings_button_pressed() -> void:
	pass


func _on_exit_button_pressed() -> void:
	exit_pressed.emit()


func set_active_camera(next_camera: Camera2D) -> void:
	%ScrollCamera.enabled = false
	%FocusCamera.enabled = false
	%TransitionCamera.enabled = false
	next_camera.enabled = true


func transition_to_camera(next_camera: Camera2D, duration: float, callback := Callable()
) -> void:
	var previous_camera = %MainViewport.get_camera_2d()
	set_active_camera(%TransitionCamera)

	# Prepare transition camera
	if previous_camera != null:
		%TransitionCamera.global_position = previous_camera.global_position
		%TransitionCamera.offset = previous_camera.offset
		%TransitionCamera.zoom = previous_camera.zoom

	var tween = (create_tween()
		.set_trans(Tween.TRANS_QUART)
		.set_ease(Tween.EASE_OUT)
		.tween_property(
			%TransitionCamera,
			"global_position",
			next_camera.global_position,
			duration
		)
	)
	(create_tween()
		.set_trans(Tween.TRANS_QUART)
		.set_ease(Tween.EASE_OUT)
		.tween_property(
			%TransitionCamera,
			"offset",
			next_camera.offset,
			duration
		)
	)
	(create_tween()
		.set_trans(Tween.TRANS_QUAD)
		.set_ease(Tween.EASE_IN_OUT)
		.tween_property(
			%TransitionCamera,
			"zoom",
			next_camera.zoom,
			duration
		)
	)
	tween.finished.connect(set_active_camera.bind(next_camera))
	if not callback.is_null():
		tween.finished.connect(callback)


func stage_topic_map(topic_data: TopicResource) -> TopicMap:
	assert(_staged_topic_map == null)

	# Build map
	_staged_topic_map = TopicMapScene.instantiate()
	staging_viewport.add_child(_staged_topic_map)
	_staged_topic_map.build(topic_data, ZOOM_SCALE)

	_update_survey_camera()

	return _staged_topic_map


func unstage_topic_map() -> void:
	assert(_staged_topic_map != null)
	_staged_topic_map.queue_free()
	_staged_topic_map = null


func enter_staged_map() -> void:
	assert(_staged_topic_map != null)

	# Remove old topic map
	if _current_topic_map != null:
		_current_topic_map.queue_free()

	# Make staged topic map current
	_staged_topic_map.reparent(%MainViewport)
	_current_topic_map = _staged_topic_map
	_staged_topic_map = null

	# Set player camera
	%CameraPoint.position = Vector2.ZERO
	%ScrollCamera.reset_smoothing()


func enter_containing_map(source_node_id: String) -> void:
	assert(has_containing_topic())

	# Need to get this before removing the current topic map
	var containing_topic_data := get_containing_topic_data()

	# Make old topic map staged
	if _current_topic_map != null:
		assert(_staged_topic_map == null)
		_current_topic_map.reparent(%StagingViewport)
		_staged_topic_map = _current_topic_map
		_update_survey_camera()

	# Build containing topic map
	_current_topic_map = TopicMapScene.instantiate()
	%MainViewport.add_child(_current_topic_map)
	_current_topic_map.build(containing_topic_data, ZOOM_SCALE)

	# Set player camera
	var source_node := _current_topic_map.get_topic_node(source_node_id)
	%CameraPoint.position = source_node.get_rect().get_center()
	%ScrollCamera.reset_smoothing()


func set_overlay(top_title: String, back_title := "") -> void:
	%TitleButton.text = top_title

	if back_title != "":
		back_button.show()
		back_button.text = back_title
	else:
		back_button.hide()


func get_current_topic_map() -> TopicMap:
	assert(_current_topic_map != null)
	return _current_topic_map


func get_containing_topic_data() -> TopicResource:
	if _current_topic_map != null:
		return _current_topic_map.topic_data.supertopic
	elif Game.current_level != null:
		return Game.current_level.topic
	else:
		return null


func has_containing_topic() -> bool:
	return get_containing_topic_data() != null


func get_camera_limit_rect() -> Rect2:
	var map_rect := _current_topic_map.get_map_rect()
	var viewport_size = %MainViewport.get_visible_rect().size
	var limit_margin = viewport_size * CAMERA_OVERSHOOT_MARGIN_RATIO
	return map_rect.grow_individual(
			limit_margin.x, limit_margin.y, limit_margin.x, limit_margin.y)


func _update_survey_camera() -> void:
	var viewport_size = %StagingViewport.get_visible_rect().size
	var camera_survey_rect := _staged_topic_map.get_map_rect().grow_individual(
			CAMERA_SURVEY_MARGIN.x, CAMERA_SURVEY_MARGIN.y,
			CAMERA_SURVEY_MARGIN.x, CAMERA_SURVEY_MARGIN.y)
	var stretched_zoom = viewport_size / camera_survey_rect.size
	var zoom_value = min(stretched_zoom.x, stretched_zoom.y)
	%SurveyCamera.zoom = Vector2(zoom_value, zoom_value)
	%SurveyCamera.position = camera_survey_rect.get_center()
