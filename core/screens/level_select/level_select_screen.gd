# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal exit_pressed
signal level_decided(level_data)
signal level_entered(level_data)
signal zoomed_in
signal zoomed_out

enum ViewportPlace {
	CURRENT,
	INNER,
	OUTER,
}

var current_viewport: SubViewport:
	get:
		if _map_containers[ViewportPlace.CURRENT] != null:
			return _map_containers[ViewportPlace.CURRENT].viewport
		return null
var inner_viewport: SubViewport:
	get:
		if _map_containers[ViewportPlace.INNER] != null:
			return _map_containers[ViewportPlace.INNER].viewport
		return null
var outer_viewport: SubViewport:
	get:
		if _map_containers[ViewportPlace.OUTER] != null:
			return _map_containers[ViewportPlace.OUTER].viewport
		return null
var current_map: TopicMap:
	get:
		if _map_containers[ViewportPlace.CURRENT] != null:
			return _map_containers[ViewportPlace.CURRENT].topic_map
		return null
var inner_map: TopicMap:
	get:
		if _map_containers[ViewportPlace.INNER] != null:
			return _map_containers[ViewportPlace.INNER].topic_map
		return null
var outer_map: TopicMap:
	get:
		if _map_containers[ViewportPlace.OUTER] != null:
			return _map_containers[ViewportPlace.OUTER].topic_map
		return null
@onready var back_button := %BackButton as Button
@onready var _map_containers: Dictionary = {
	ViewportPlace.CURRENT: null,
	ViewportPlace.INNER: null,
	ViewportPlace.OUTER: null,
	"unused": [
		%TopicMapContainer3,
		%TopicMapContainer2,
		%TopicMapContainer1,
	]
}


func _enter_tree() -> void:
	CSConnector.with(self).connect_setup("level_nodes", _setup_level_node)


func _ready() -> void:
	assert(Game.root_topic != null)

	use_new_viewport(ViewportPlace.CURRENT)
	if Game.current_level == null:
		add_topic_map(Game.root_topic, ViewportPlace.CURRENT)
		current_map.set_active_camera(current_map.scroll_camera)
		current_map.scroll_camera.reset_smoothing()
		current_map.camera_point.position = Vector2.ZERO
	else:
		add_topic_map(Game.current_level.topic, ViewportPlace.CURRENT)
		current_map.set_active_camera(current_map.scroll_camera)
		current_map.scroll_camera.reset_smoothing()
		current_map.focus_on_node_id(Game.current_level.id)

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


func use_new_viewport(viewport_place: ViewportPlace) -> SubViewport:
	assert(not _map_containers.unused.is_empty())
	assert(_map_containers[viewport_place] == null)

	var viewport_container = _map_containers.unused.pop_back()
	_map_containers[viewport_place] = viewport_container
	if viewport_place == ViewportPlace.CURRENT:
		_map_containers[viewport_place].move_to_front()
	return viewport_container.viewport


func disuse_viewport(viewport_place: ViewportPlace) -> void:
	if _map_containers[viewport_place] == null:
		return

	var viewport_container = _map_containers[viewport_place]
	viewport_container.disuse()
	_map_containers[viewport_place] = null
	_map_containers.unused.append(viewport_container)


func add_topic_map(topic_data: TopicResource, viewport_place: ViewportPlace) -> TopicMap:
	return _map_containers[viewport_place].add_topic_map(topic_data)


func shift_viewports_in() -> void:
	disuse_viewport(ViewportPlace.INNER)
	_map_containers[ViewportPlace.INNER] = _map_containers[ViewportPlace.CURRENT]
	_map_containers[ViewportPlace.CURRENT] = _map_containers[ViewportPlace.OUTER]
	_map_containers[ViewportPlace.CURRENT].move_to_front()
	_map_containers[ViewportPlace.OUTER] = null


func shift_viewports_out() -> void:
	disuse_viewport(ViewportPlace.OUTER)
	_map_containers[ViewportPlace.OUTER] = _map_containers[ViewportPlace.CURRENT]
	_map_containers[ViewportPlace.CURRENT] = _map_containers[ViewportPlace.INNER]
	_map_containers[ViewportPlace.CURRENT].move_to_front()
	_map_containers[ViewportPlace.INNER] = null


func set_overlay(top_title: String, back_title := "") -> void:
	%TitleButton.text = top_title

	if back_title != "":
		back_button.show()
		back_button.text = back_title
	else:
		back_button.hide()
