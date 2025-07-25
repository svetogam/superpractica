# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

enum ViewportPlace {
	CURRENT,
	INNER,
	OUTER,
}

const ZOOM_IN_TO_SUBTOPIC_NODE_DURATION := 0.45
const ZOOM_IN_TO_LEVEL_NODE_DURATION := 0.50
const ZOOM_OUT_FROM_NODE_TO_MAP_DURATION := 0.3
const ZOOM_IN_FROM_NODE_TO_MAP_DURATION := 0.45
const ZOOM_OUT_FROM_MAP_TO_NODE_DURATION := 0.3
const ZOOM_IN_FROM_NODE_TO_LEVEL_DURATION := 0.45
const ZOOM_OUT_FROM_LEVEL_TO_MAP_DURATION := 0.45
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
	"unused":
	[
		%TopicMapContainer3,
		%TopicMapContainer2,
		%TopicMapContainer1,
	]
}


func _enter_tree() -> void:
	CSLocator.with(self).connect_service_found(
		Game.SERVICE_PIMNET_LEVEL_VIEWPORT, _on_level_viewport_found
	)


func _on_level_viewport_found(p_level_viewport: SubViewport) -> void:
	level_viewport = p_level_viewport


func _ready() -> void:
	assert(Game.root_topic != null)

	overlay.back_button.pressed.connect(_on_back_button_pressed)

	use_new_viewport(ViewportPlace.CURRENT)
	var loaded_level_data = CSLocator.with(self).find(Game.SERVICE_LEVEL_DATA)
	if loaded_level_data == null:
		add_topic_map(Game.root_topic, ViewportPlace.CURRENT)
		current_map.set_camera_point_to_origin()
		$StateChart.send_event.call_deferred("activate_normal")
	else:
		add_topic_map(loaded_level_data.topic, ViewportPlace.CURRENT)
		current_map.set_camera_point_to_node(loaded_level_data.id)
		current_map.focus_on_node(loaded_level_data.id)
		current_map.focused_node.view_detail(level_viewport)


func start_from_level() -> void:
	$StateChart.send_event.call_deferred("activate_from_level")


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


func _on_node_pressed(node: TopicNode) -> void:
	if $StateChart/Camera/Map/Scrolling.active:
		if node is LevelNode:
			Game.request_load_level.emit(node.level_data)
			# Wait a little as level loads to reduce stuttering
			await get_tree().process_frame
			await get_tree().process_frame
		current_map.focus_on_node(node.id)
		$StateChart.send_event("zoom_in")
	elif $StateChart/Camera/Node/Viewing.active:
		if node is LevelNode:
			$StateChart.send_event("zoom_in_to_level")
		elif node is SubtopicNode:
			$StateChart.send_event("zoom_in_to_map")
		else:
			assert(false)


func _on_back_button_pressed() -> void:
	if $StateChart/Camera/Map/Scrolling.active:
		$StateChart.send_event("zoom_out")
	elif $StateChart/Camera/Node/Viewing.active:
		$StateChart.send_event("zoom_out")


func _on_map_scrolling_state_entered() -> void:
	current_map.focused_node = null

	current_map.set_active_camera(TopicMap.TopicCamera.SCROLL)
	overlay.set_topic(current_map.topic_data)
	overlay.system_button.disabled = false
	overlay.slide_title_in()
	overlay.slide_back_button_in()

	current_map.camera_point.draggable = true
	current_map.camera_point.force_stop_dragging()
	current_map.scroll_camera.position_smoothing_enabled = true
	current_map.node_pressed.connect(_on_node_pressed)

	for node in current_map.get_topic_nodes():
		if node.main_button.is_hovered():
			node.pop()
		node.main_button.mouse_entered.connect(node.pop)
		node.main_button.mouse_exited.connect(node.unpop)

	# Prepare outer topic-map if necessary
	var topic_data = current_map.topic_data
	if outer_viewport == null and topic_data.supertopic != null:
		use_new_viewport(ViewportPlace.OUTER)
		add_topic_map(topic_data.supertopic, ViewportPlace.OUTER)
		outer_map.set_active_camera(TopicMap.TopicCamera.THUMBNAIL)
		outer_map.focus_on_node(topic_data.id)
		outer_map.focused_node.view_detail(current_viewport)


func _on_map_scrolling_state_exited() -> void:
	current_map.camera_point.draggable = false
	current_map.scroll_camera.position_smoothing_enabled = false
	current_map.node_pressed.disconnect(_on_node_pressed)

	for node in current_map.get_topic_nodes():
		node.unpop()
		node.main_button.mouse_entered.disconnect(node.pop)
		node.main_button.mouse_exited.disconnect(node.unpop)


func _on_map_zooming_in_state_entered() -> void:
	overlay.system_button.disabled = true
	overlay.slide_back_button_out()

	var focused_node = current_map.focused_node
	var next_camera: Camera2D
	if focused_node is SubtopicNode:
		use_new_viewport(ViewportPlace.INNER)
		add_topic_map(focused_node.topic_data, ViewportPlace.INNER)
		inner_map.set_active_camera(TopicMap.TopicCamera.SURVEY)
		focused_node.view_detail(inner_viewport, ZOOM_IN_TO_SUBTOPIC_NODE_DURATION)
		current_map.transition_camera.duration = ZOOM_IN_TO_SUBTOPIC_NODE_DURATION
		next_camera = current_map.subtopic_focus_camera
	elif focused_node is LevelNode:
		focused_node.view_detail(level_viewport, ZOOM_IN_TO_LEVEL_NODE_DURATION)
		current_map.transition_camera.duration = ZOOM_IN_TO_LEVEL_NODE_DURATION
		next_camera = current_map.level_focus_camera
	else:
		assert(false)

	current_map.transition_camera.position_ease = Tween.EASE_OUT
	current_map.transition_camera.transition_to(next_camera)
	$StateChart.set_expression_property(
		"zoom_duration", current_map.transition_camera.duration
	)


func _on_map_zooming_out_state_entered() -> void:
	overlay.system_button.disabled = true
	overlay.slide_back_button_out()
	overlay.slide_title_out()

	current_map.transition_camera.duration = ZOOM_OUT_FROM_MAP_TO_NODE_DURATION
	current_map.transition_camera.position_ease = Tween.EASE_IN_OUT
	current_map.transition_camera.transition_to(current_map.survey_camera)
	outer_map.update_thumbnail_camera()
	outer_map.transition_camera.duration = ZOOM_OUT_FROM_MAP_TO_NODE_DURATION
	outer_map.transition_camera.position_ease = Tween.EASE_OUT
	outer_map.transition_camera.transition(
		outer_map.thumbnail_camera, outer_map.subtopic_focus_camera
	)
	$StateChart.set_expression_property(
		"zoom_duration", ZOOM_OUT_FROM_MAP_TO_NODE_DURATION
	)

	shift_viewports_in()


func _on_node_viewing_state_entered() -> void:
	var focused_node = current_map.focused_node
	if focused_node is SubtopicNode:
		current_map.set_active_camera(TopicMap.TopicCamera.SUBTOPIC_FOCUS)
	elif focused_node is LevelNode:
		current_map.set_active_camera(TopicMap.TopicCamera.LEVEL_FOCUS)
	else:
		assert(false)

	overlay.set_topic(current_map.topic_data)
	overlay.system_button.disabled = false
	overlay.slide_title_in()

	current_map.node_pressed.connect(_on_node_pressed)

	if not focused_node.main_button.is_hovered():
		focused_node.fade_thumbnail()
	focused_node.main_button.mouse_entered.connect(focused_node.unfade_thumbnail)
	focused_node.main_button.mouse_exited.connect(focused_node.fade_thumbnail)


func _on_node_viewing_state_exited() -> void:
	current_map.node_pressed.disconnect(_on_node_pressed)

	var focused_node = current_map.focused_node
	focused_node.unfade_thumbnail()
	focused_node.main_button.mouse_entered.disconnect(focused_node.unfade_thumbnail)
	focused_node.main_button.mouse_exited.disconnect(focused_node.fade_thumbnail)


func _on_node_viewing_state_unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("primary_mouse"):
		$StateChart.send_event("zoom_out")


func _on_node_zooming_out_state_entered() -> void:
	assert(current_map.focused_node != null)

	overlay.system_button.disabled = true

	current_map.focused_node.view_mask(ZOOM_OUT_FROM_NODE_TO_MAP_DURATION)
	current_map.set_camera_point_to_node(current_map.focused_node.id)
	current_map.transition_camera.duration = ZOOM_OUT_FROM_NODE_TO_MAP_DURATION
	current_map.transition_camera.position_ease = Tween.EASE_OUT
	current_map.transition_camera.transition_to(current_map.scroll_camera)
	$StateChart.set_expression_property(
		"zoom_duration", ZOOM_OUT_FROM_NODE_TO_MAP_DURATION
	)


func _on_node_zooming_out_state_exited() -> void:
	if current_map.focused_node is SubtopicNode:
		disuse_viewport(ViewportPlace.INNER)
	elif current_map.focused_node is LevelNode:
		Game.request_unload_level.emit()


func _on_node_zooming_in_to_map_state_entered() -> void:
	overlay.system_button.disabled = true
	overlay.slide_title_out()

	if outer_viewport != null:
		disuse_viewport(ViewportPlace.OUTER)

	inner_map.set_camera_point_to_origin()
	current_map.update_thumbnail_camera()
	current_map.transition_camera.duration = ZOOM_IN_FROM_NODE_TO_MAP_DURATION
	current_map.transition_camera.position_ease = Tween.EASE_OUT
	current_map.transition_camera.transition_to(current_map.thumbnail_camera)
	inner_map.transition_camera.duration = ZOOM_IN_FROM_NODE_TO_MAP_DURATION
	inner_map.transition_camera.position_ease = Tween.EASE_IN_OUT
	inner_map.transition_camera.transition_to(inner_map.scroll_camera)
	$StateChart.set_expression_property(
		"zoom_duration", ZOOM_IN_FROM_NODE_TO_MAP_DURATION
	)


func _on_node_zooming_in_to_map_state_exited() -> void:
	shift_viewports_out()


func _on_node_zooming_in_to_level_state_entered() -> void:
	assert(current_map.focused_node is LevelNode)

	overlay.system_button.disabled = true
	overlay.slide_title_out()

	current_map.update_thumbnail_camera()
	current_map.transition_camera.duration = ZOOM_IN_FROM_NODE_TO_LEVEL_DURATION
	current_map.transition_camera.position_ease = Tween.EASE_OUT
	current_map.transition_camera.transition_to(
		current_map.thumbnail_camera, _on_zoom_into_level
	)


func _on_zoom_into_level() -> void:
	assert(current_map.focused_level != null)

	Game.request_enter_level.emit(current_map.focused_level)


func _on_zooming_out_from_level_state_entered() -> void:
	overlay.system_button.disabled = true
	overlay.slide_title_out(0.0)
	overlay.slide_back_button_out(0.0)

	current_map.focused_node.view_mask(ZOOM_OUT_FROM_LEVEL_TO_MAP_DURATION)
	current_map.set_active_camera(TopicMap.TopicCamera.THUMBNAIL)
	overlay.set_topic(current_map.topic_data)

	current_map.update_thumbnail_camera()
	current_map.transition_camera.duration = ZOOM_OUT_FROM_LEVEL_TO_MAP_DURATION
	current_map.transition_camera.position_ease = Tween.EASE_OUT
	current_map.transition_camera.transition_to(current_map.scroll_camera)
	$StateChart.set_expression_property(
		"zoom_duration", ZOOM_OUT_FROM_LEVEL_TO_MAP_DURATION
	)


func _on_zooming_out_from_level_state_exited() -> void:
	Game.request_unload_level.emit()
