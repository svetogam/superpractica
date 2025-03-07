# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal exit_pressed
signal level_entered(level_data)
signal zoomed_in
signal zoomed_out

const ZOOM_SCALE := 10.0
const NODE_ZOOM := Vector2(7.0, 7.0) / ZOOM_SCALE
const MAP_ZOOM := Vector2(1.0, 1.0) / ZOOM_SCALE
const ZOOM_IN_DURATION := 0.5
const ZOOM_OUT_DURATION := 0.35
const CAMERA_OVERSHOOT_MARGIN_RATIO := 0.25 * ZOOM_SCALE
const CAMERA_SURVEY_MARGIN := Vector2(80.0, 60.0) * ZOOM_SCALE
const TopicMapScene := preload("topic_map/topic_map.tscn")

var _staged_topic_map: TopicMap
var _current_topic_map: TopicMap
@onready var back_button := %BackButton as Button
@onready var staging_viewport := %StagingViewport as SubViewport
@onready var player_camera := %PlayerCamera as Camera2D
@onready var camera_point := %CameraPoint as Node2D


func _ready() -> void:
	assert(Game.root_topic != null)

	if Game.current_level == null:
		stage_topic_map(Game.root_topic)
		enter_staged_map()
	else:
		enter_containing_map(Game.current_level.id)

	$StateMachine.activate()


func _on_menu_button_pressed() -> void:
	%MenuPopup.show()


func _on_continue_button_pressed() -> void:
	%MenuPopup.hide()


func _on_settings_button_pressed() -> void:
	pass


func _on_exit_button_pressed() -> void:
	exit_pressed.emit()


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
	camera_point.position = Vector2.ZERO
	player_camera.reset_smoothing()


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
	camera_point.position = source_node.get_rect().get_center()
	player_camera.reset_smoothing()


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
