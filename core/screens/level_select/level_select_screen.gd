# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

signal zooming_started
signal zooming_stopped

enum ViewportPlace {
	CURRENT,
	INNER,
	OUTER,
}

var level_viewport: SubViewport
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
@onready var overlay := %Overlay as Control
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
	CSLocator.with(self).connect_service_found(
			Game.SERVICE_PIMNET_LEVEL_VIEWPORT, _on_level_viewport_found)


func _on_level_viewport_found(p_level_viewport: SubViewport) -> void:
	level_viewport = p_level_viewport


func _ready() -> void:
	assert(Game.root_topic != null)

	use_new_viewport(ViewportPlace.CURRENT)
	var loaded_level_data = CSLocator.with(self).find(Game.SERVICE_LEVEL_DATA)
	if loaded_level_data == null:
		add_topic_map(Game.root_topic, ViewportPlace.CURRENT)
		current_map.set_camera_point_to_origin()
		$StateMachine.activate("MapView")
	else:
		add_topic_map(loaded_level_data.topic, ViewportPlace.CURRENT)
		current_map.set_camera_point_to_node(loaded_level_data.id)
		current_map.focus_on_node(loaded_level_data.id)
		current_map.focused_node.view_detail(level_viewport)


func start_from_level() -> void:
	$StateMachine.activate("OutFromLevelToMap")


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
