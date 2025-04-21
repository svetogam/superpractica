# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicMap
extends Node

signal node_pressed(node)

enum TopicCamera {
	SCROLL,
	FOCUS,
	THUMBNAIL,
	SURVEY,
	TRANSITION,
}

const ZOOM_SCALE := 10.0 # Should equal 1 / ScrollCamera.zoom
const ORIGIN = Vector2.ZERO
const CAMERA_OVERSHOOT_MARGIN_RATIO := 0.25 * ZOOM_SCALE
const CAMERA_SURVEY_MARGIN := Vector2(80.0, 60.0) * ZOOM_SCALE
const CONNECTOR_LINE_WIDTH := 4.0
const CONNECTOR_LINE_COLOR := Color.BLACK
const ARROWHEAD_WIDTH := 18.0
const ARROWHEAD_LENGTH := 15.0
const BOX_LINE_WIDTH := 8.0
const BOX_MARGIN := Vector2(50.0, 40.0)
const BOX_COLOR := Color.DARK_SLATE_GRAY
const LevelNodeScene := preload("topic_nodes/level_node.tscn")
const SubtopicNodeScene := preload("topic_nodes/subtopic_node.tscn")

var topic_data: TopicResource
var focused_node: Control
var focused_level: LevelResource:
	get:
		if focused_node != null and focused_node is LevelNode:
			return focused_node.level_data
		return null
var _node_ids_to_nodes: Dictionary
@onready var camera_point := %CameraPoint as Node2D
@onready var scroll_camera := %ScrollCamera as Camera2D
@onready var focus_camera := %FocusCamera as Camera2D
@onready var thumbnail_camera := %ThumbnailCamera as Camera2D
@onready var survey_camera := %SurveyCamera as Camera2D
@onready var transition_camera := %TransitionCamera as Camera2D
var _cameras: Dictionary:
	get:
		return {
			TopicCamera.SCROLL: scroll_camera,
			TopicCamera.FOCUS: focus_camera,
			TopicCamera.THUMBNAIL: thumbnail_camera,
			TopicCamera.SURVEY: survey_camera,
			TopicCamera.TRANSITION: transition_camera,
		}


func build(p_topic_data: TopicResource) -> void:
	assert(p_topic_data != null)
	assert(topic_data == null)
	topic_data = p_topic_data

	# Build layout
	for level_data in topic_data.get_levels():
		var level_node := LevelNodeScene.instantiate()
		level_node.setup(level_data)
		level_node.name = level_node.id
		_node_ids_to_nodes[level_node.id] = level_node
	for subtopic_data in topic_data.get_subtopics():
		var subtopic_node := SubtopicNodeScene.instantiate()
		subtopic_node.setup(subtopic_data)
		subtopic_node.name = subtopic_node.id
		_node_ids_to_nodes[subtopic_node.id] = subtopic_node
	for node in _node_ids_to_nodes.values():
		node.position = topic_data.get_node_position(node.id) * ZOOM_SCALE
		add_child(node)

	# Connect node signals
	for node in _node_ids_to_nodes.values():
		node.mask_button.pressed.connect(node_pressed.emit.bind(node))

	# Add connectors
	for connection in topic_data.connections:
		add_child(_build_line(
				_node_ids_to_nodes[connection.source_node_id],
				_node_ids_to_nodes[connection.dest_node_id],
				connection.start_direction, connection.end_direction))

	# Add groups
	for topic_group in topic_data.groups:
		var nodes: Array = []
		for node_id in topic_group.node_ids:
			nodes.append(_node_ids_to_nodes[node_id])
		add_child(_build_box(nodes))

	# Set up cameras
	camera_point.bounds = get_camera_limit_rect()
	_update_survey_camera()


func show_node_detail(node_id: String, thumbnail_viewport: SubViewport) -> void:
	focused_node = _node_ids_to_nodes[node_id]
	focused_node.mask.hide()
	focused_node.overview_panel.show()
	focused_node.set_thumbnail(thumbnail_viewport)

	# Update cameras
	_update_focus_camera()
	_update_thumbnail_camera.call_deferred.call_deferred()


func hide_node_detail() -> void:
	if focused_node != null:
		focused_node.mask.show()
		focused_node.overview_panel.hide()
		focused_node = null


func set_active_camera(next_camera: TopicCamera) -> void:
	scroll_camera.enabled = false
	focus_camera.enabled = false
	thumbnail_camera.enabled = false
	survey_camera.enabled = false
	transition_camera.enabled = false

	_cameras[next_camera].enabled = true


func set_camera_point_to_origin() -> void:
	camera_point.position = ORIGIN


func set_camera_point_to_node(node_id: String) -> void:
	camera_point.position = get_topic_node(node_id).get_rect().get_center()


func get_topic_node(node_id: String) -> TopicNode:
	return _node_ids_to_nodes[node_id]


func get_map_rect() -> Rect2:
	return Utils.get_combined_control_rect(_node_ids_to_nodes.values())


func get_camera_limit_rect() -> Rect2:
	var map_rect := get_map_rect()
	var viewport_size = get_viewport().get_visible_rect().size
	var limit_margin = viewport_size * CAMERA_OVERSHOOT_MARGIN_RATIO
	return map_rect.grow_individual(
			limit_margin.x, limit_margin.y, limit_margin.x, limit_margin.y)


func _update_survey_camera() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var camera_survey_rect := get_map_rect().grow_individual(
			CAMERA_SURVEY_MARGIN.x, CAMERA_SURVEY_MARGIN.y,
			CAMERA_SURVEY_MARGIN.x, CAMERA_SURVEY_MARGIN.y)
	var stretched_zoom = viewport_size / camera_survey_rect.size
	var zoom_value = min(stretched_zoom.x, stretched_zoom.y)
	survey_camera.zoom = Vector2(zoom_value, zoom_value)
	survey_camera.position = camera_survey_rect.get_center()


func _update_focus_camera() -> void:
	assert(focused_node is LevelNode or focused_node is SubtopicNode)

	focus_camera.position = focused_node.get_rect().get_center()


func _update_thumbnail_camera() -> void:
	assert(focused_node is LevelNode or focused_node is SubtopicNode)

	var level_texture_rect = focused_node.get_thumbnail_rect()
	thumbnail_camera.global_position = level_texture_rect.get_center()
	thumbnail_camera.zoom = Vector2(
		get_viewport().get_visible_rect().size.x / level_texture_rect.size.x,
		get_viewport().get_visible_rect().size.y / level_texture_rect.size.y
	)


#====================================================================
# Connectors
#====================================================================

func _build_line(source_node: Control, dest_node: Control,
		start_direction: Utils.Direction, end_direction: Utils.Direction
) -> Line2D:
	# Convert directions to sides
	var start_side: Side
	var end_side: Side
	match start_direction:
		Utils.Direction.LEFT:
			start_side = Side.SIDE_LEFT
		Utils.Direction.RIGHT:
			start_side = Side.SIDE_RIGHT
		Utils.Direction.UP:
			start_side = Side.SIDE_TOP
		Utils.Direction.DOWN:
			start_side = Side.SIDE_BOTTOM
		_:
			assert(false)
	match end_direction:
		Utils.Direction.LEFT:
			end_side = Side.SIDE_RIGHT
		Utils.Direction.RIGHT:
			end_side = Side.SIDE_LEFT
		Utils.Direction.UP:
			end_side = Side.SIDE_BOTTOM
		Utils.Direction.DOWN:
			end_side = Side.SIDE_TOP
		_:
			assert(false)
	assert(start_side != end_side)

	# Find points
	var start_point := Utils.get_point_at_side(source_node, start_side)
	var end_point := Utils.get_point_at_side(dest_node, end_side)
	var turn_points: Array = []
	match start_side:
		Side.SIDE_LEFT, Side.SIDE_RIGHT:
			match end_side:
				Side.SIDE_LEFT, Side.SIDE_RIGHT:
					turn_points = _get_2_orthogonal_midpoints(
							start_point, end_point, false)
				Side.SIDE_TOP, Side.SIDE_BOTTOM:
					var point = _get_orthogonal_midpoint(start_point, end_point, false)
					turn_points.append(point)
		Side.SIDE_TOP, Side.SIDE_BOTTOM:
			match end_side:
				Side.SIDE_LEFT, Side.SIDE_RIGHT:
					var point = _get_orthogonal_midpoint(start_point, end_point, true)
					turn_points.append(point)
				Side.SIDE_TOP, Side.SIDE_BOTTOM:
					turn_points = _get_2_orthogonal_midpoints(
							start_point, end_point, true)

	# Build line
	var line := Line2D.new()
	line.width = CONNECTOR_LINE_WIDTH * ZOOM_SCALE
	line.default_color = CONNECTOR_LINE_COLOR
	line.add_point(start_point)
	for point in turn_points:
		line.add_point(point)
	var arrowhead_direction = Utils.side_to_vector(end_side) * -1
	var short_end_point = end_point - arrowhead_direction * ARROWHEAD_LENGTH * ZOOM_SCALE
	line.add_point(short_end_point)
	line.add_child(_build_arrowhead(end_point, arrowhead_direction))

	return line


func _get_orthogonal_midpoint(point_1: Vector2, point_2: Vector2, vertical_first: bool
) -> Vector2:
	if vertical_first:
		return Vector2(point_1.x, point_2.y)
	else:
		return Vector2(point_2.x, point_1.y)


func _get_2_orthogonal_midpoints(point_1: Vector2, point_2: Vector2, vertical_first: bool
) -> Array:
	if vertical_first:
		var first := Vector2(point_1.x, (point_1.y + point_2.y) / 2)
		var second := Vector2(point_2.x, (point_1.y + point_2.y) / 2)
		return [first, second]
	else:
		var first := Vector2((point_1.x + point_2.x) / 2, point_1.y)
		var second := Vector2((point_1.x + point_2.x) / 2, point_2.y)
		return [first, second]


func _build_arrowhead(tip_point: Vector2, direction: Vector2) -> Polygon2D:
	var arrowhead := Polygon2D.new()
	arrowhead.polygon = [
		Vector2.ZERO,
		Vector2(-ARROWHEAD_LENGTH * ZOOM_SCALE, ARROWHEAD_WIDTH * ZOOM_SCALE / 2),
		Vector2(-ARROWHEAD_LENGTH * ZOOM_SCALE, -ARROWHEAD_WIDTH * ZOOM_SCALE / 2)
	]
	arrowhead.color = CONNECTOR_LINE_COLOR
	arrowhead.position = tip_point

	if direction == Vector2.RIGHT:
		arrowhead.rotation_degrees = 0.0
	elif direction == Vector2.DOWN:
		arrowhead.rotation_degrees = 90.0
	elif direction == Vector2.LEFT:
		arrowhead.rotation_degrees = 180.0
	elif direction == Vector2.UP:
		arrowhead.rotation_degrees = 270.0
	else:
		assert(false)

	return arrowhead


#====================================================================
# Boxes
#====================================================================

func _build_box(nodes: Array) -> Line2D:
	assert(nodes.size() > 1)

	var box = Line2D.new()
	box.closed = true
	box.width = BOX_LINE_WIDTH * ZOOM_SCALE
	box.joint_mode = Line2D.LINE_JOINT_ROUND
	box.default_color = BOX_COLOR
	box.z_index = -10

	var rect := Utils.get_combined_control_rect(nodes)
	box.add_point(Vector2(rect.position.x - BOX_MARGIN.x * ZOOM_SCALE,
			rect.position.y - BOX_MARGIN.y * ZOOM_SCALE))
	box.add_point(Vector2(rect.end.x + BOX_MARGIN.x * ZOOM_SCALE,
			rect.position.y - BOX_MARGIN.y * ZOOM_SCALE))
	box.add_point(Vector2(rect.end.x + BOX_MARGIN.x * ZOOM_SCALE,
			rect.end.y + BOX_MARGIN.y * ZOOM_SCALE))
	box.add_point(Vector2(rect.position.x - BOX_MARGIN.x * ZOOM_SCALE,
			rect.end.y + BOX_MARGIN.y * ZOOM_SCALE))
	return box
