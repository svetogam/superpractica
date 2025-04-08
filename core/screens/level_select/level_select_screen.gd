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

var current_viewport: SubViewport
var staging_viewport: SubViewport
var containing_viewport: SubViewport
var current_topic_map: TopicMap:
	get:
		if current_viewport == null:
			return null
		return current_viewport.get_child(0)
var staged_topic_map: TopicMap:
	get:
		if staging_viewport == null:
			return null
		return staging_viewport.get_child(0)
var containing_topic_map: TopicMap:
	get:
		if containing_viewport == null:
			return null
		return containing_viewport.get_child(0)
@onready var back_button := %BackButton as Button
@onready var _unused_viewports: Array = [
	%TopicMapViewport3,
	%TopicMapViewport2,
	%TopicMapViewport1,
]


func _enter_tree() -> void:
	CSConnector.with(self).connect_setup("level_nodes", _setup_level_node)


func _ready() -> void:
	assert(Game.root_topic != null)

	var viewport = get_unused_viewport()

	if Game.current_level == null:
		add_topic_map_to_viewport(Game.root_topic, viewport)
		make_viewport_current(viewport)
		current_topic_map.set_active_camera(current_topic_map.scroll_camera)
		current_topic_map.scroll_camera.reset_smoothing()
		current_topic_map.camera_point.position = Vector2.ZERO
	else:
		add_topic_map_to_viewport(Game.current_level.topic, viewport)
		make_viewport_current(viewport)
		current_topic_map.set_active_camera(current_topic_map.scroll_camera)
		current_topic_map.scroll_camera.reset_smoothing()
		current_topic_map.focus_on_node_id(Game.current_level.id)

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


func add_topic_map_to_viewport(topic_data: TopicResource, viewport: SubViewport
) -> TopicMap:
	var topic_map = TopicMapScene.instantiate()
	viewport.add_child(topic_map)
	topic_map.build(topic_data, ZOOM_SCALE)

	return topic_map


func make_viewport_current(viewport: SubViewport) -> void:
	current_viewport = viewport
	viewport.get_parent().move_to_front()


func make_viewport_preview(viewport: SubViewport) -> void:
	staging_viewport = viewport

	staged_topic_map.set_active_camera(staged_topic_map.survey_camera)
	staged_topic_map.update_survey_camera()


func make_viewport_containing(viewport: SubViewport) -> void:
	containing_viewport = viewport


func disuse_viewport(viewport: SubViewport) -> void:
	var topic_map = viewport.get_child(0)
	topic_map.free()
	_unused_viewports.append(viewport)


func get_unused_viewport() -> SubViewport:
	assert(not _unused_viewports.is_empty())
	var viewport = _unused_viewports.pop_back()
	return viewport


func set_overlay(top_title: String, back_title := "") -> void:
	%TitleButton.text = top_title

	if back_title != "":
		back_button.show()
		back_button.text = back_title
	else:
		back_button.hide()


func get_containing_topic_data() -> TopicResource:
	if current_topic_map != null:
		return current_topic_map.topic_data.supertopic
	elif Game.current_level != null:
		return Game.current_level.topic
	else:
		return null


func has_containing_topic() -> bool:
	return get_containing_topic_data() != null


func get_camera_limit_rect() -> Rect2:
	var map_rect := current_topic_map.get_map_rect()
	var viewport_size = current_viewport.get_visible_rect().size
	var limit_margin = viewport_size * CAMERA_OVERSHOOT_MARGIN_RATIO
	return map_rect.grow_individual(
			limit_margin.x, limit_margin.y, limit_margin.x, limit_margin.y)
