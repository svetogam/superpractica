# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicMap
extends Node

signal node_pressed(node)

enum TopicCamera {
	SCROLL,
	LEVEL_FOCUS,
	SUBTOPIC_FOCUS,
	THUMBNAIL,
	SURVEY,
	TRANSITION,
}
enum Backgrounds {
	GREEN_TRIANGLES = 0,
	BLUE_TRIANGLES,
}

const ZOOM_SCALE := 8.5
const ORIGIN = Vector2.ZERO
const CAMERA_OVERSHOOT_MARGIN_RATIO := 0.25 * ZOOM_SCALE
const CAMERA_SURVEY_MARGIN := Vector2(80.0, 60.0) * ZOOM_SCALE
const THIN_CONNECTOR_WIDTH := 32.0
const THICK_CONNECTOR_WIDTH := 80.0
const CONNECTOR_LINE_COLOR := Color.WHITE
const BOX_LINE_WIDTH := 64.0
const BOX_MARGIN := Vector2(50.0, 40.0)
const BOX_COLOR := Color.DARK_SLATE_GRAY
const LevelNodeScene := preload("topic_nodes/level_node.tscn")
const SubtopicNodeScene := preload("topic_nodes/subtopic_node.tscn")
const GreenTrianglesTexture := preload("uid://cx3rph7u0xbiq")
const BlueTrianglesTexture := preload("uid://c4tjv8ugcf1d8")

var topic_data: TopicResource
var focused_node: Node2D
var focused_level: LevelResource:
	get:
		if focused_node != null and focused_node is LevelNode:
			return focused_node.level_data
		return null
var _node_ids_to_nodes: Dictionary
@onready var camera_point := %CameraPoint as Node2D
@onready var scroll_camera := %ScrollCamera as Camera2D
@onready var level_focus_camera := %LevelFocusCamera as Camera2D
@onready var subtopic_focus_camera := %SubtopicFocusCamera as Camera2D
@onready var thumbnail_camera := %ThumbnailCamera as Camera2D
@onready var survey_camera := %SurveyCamera as Camera2D
@onready var transition_camera := %TransitionCamera as Camera2D
var _cameras: Dictionary:
	get:
		return {
			TopicCamera.SCROLL: scroll_camera,
			TopicCamera.LEVEL_FOCUS: level_focus_camera,
			TopicCamera.SUBTOPIC_FOCUS: subtopic_focus_camera,
			TopicCamera.THUMBNAIL: thumbnail_camera,
			TopicCamera.SURVEY: survey_camera,
			TopicCamera.TRANSITION: transition_camera,
		}
var _backgrounds: Dictionary:
	get:
		return {
			Backgrounds.GREEN_TRIANGLES: GreenTrianglesTexture,
			Backgrounds.BLUE_TRIANGLES: BlueTrianglesTexture,
		}


func _ready() -> void:
	scroll_camera.zoom = Vector2(1.0 / ZOOM_SCALE, 1.0 / ZOOM_SCALE)


func build(p_topic_data: TopicResource) -> void:
	assert(p_topic_data != null)
	assert(topic_data == null)
	topic_data = p_topic_data

	# Build layout
	var suggested_level_ids = topic_data.get_suggested_level_ids()
	for level_data in topic_data.get_levels():
		var node := LevelNodeScene.instantiate()
		add_child(node)
		node.setup(level_data)
		node.name = node.id
		node.position = topic_data.get_node_position(node.id) * ZOOM_SCALE
		if suggested_level_ids.has(node.id):
			node.suggested = true
		_node_ids_to_nodes[node.id] = node
	for subtopic_data in topic_data.get_subtopics():
		var node := SubtopicNodeScene.instantiate()
		add_child(node)
		node.setup(subtopic_data)
		node.name = node.id
		node.position = topic_data.get_node_position(node.id) * ZOOM_SCALE
		_node_ids_to_nodes[node.id] = node

	# Connect node signals
	for node in _node_ids_to_nodes.values():
		node.main_button.button_down.connect(node_pressed.emit.bind(node))

	# Add background
	%BackgroundTile.texture = _backgrounds[topic_data.bg_texture]
	%BackgroundParallax.repeat_size = %BackgroundTile.size

	# Add groups
	for topic_group in topic_data.groups:
		var nodes: Array = []
		for node_id in topic_group.node_ids:
			nodes.append(_node_ids_to_nodes[node_id])
		%BackgroundLayer.add_child(_build_box(nodes))

	# Add connectors
	for connection in topic_data.connections:
		var line := _build_line(
			_node_ids_to_nodes[connection.source_node_id],
			_node_ids_to_nodes[connection.dest_node_id],
			connection.start_direction,
			connection.end_direction
		)
		%BackgroundLayer.add_child(line)

	# Set up cameras
	camera_point.bounds = get_camera_limit_rect()
	_update_survey_camera()


func focus_on_node(node_id: String) -> void:
	focused_node = _node_ids_to_nodes[node_id]
	level_focus_camera.position = focused_node.position
	subtopic_focus_camera.position = focused_node.position


func set_active_camera(next_camera: TopicCamera) -> void:
	scroll_camera.enabled = false
	level_focus_camera.enabled = false
	subtopic_focus_camera.enabled = false
	thumbnail_camera.enabled = false
	survey_camera.enabled = false
	transition_camera.enabled = false

	_cameras[next_camera].enabled = true


func set_camera_point_to_origin() -> void:
	camera_point.position = ORIGIN


func set_camera_point_to_node(node_id: String) -> void:
	camera_point.position = get_topic_node(node_id).position


func update_thumbnail_camera() -> void:
	var thumbnail_rect = focused_node.get_thumbnail_rect()
	thumbnail_camera.global_position = thumbnail_rect.get_center()
	thumbnail_camera.zoom = Vector2(
		get_viewport().get_visible_rect().size.x / thumbnail_rect.size.x,
		get_viewport().get_visible_rect().size.y / thumbnail_rect.size.y
	)


func get_topic_node(node_id: String) -> TopicNode:
	return _node_ids_to_nodes[node_id]


func get_map_rect() -> Rect2:
	var boxes: Array = []
	for node in _node_ids_to_nodes.values():
		boxes.append(node.box)
	return Utils.get_combined_control_rect(boxes)


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


#====================================================================
# Connectors
#====================================================================

func _build_line(source_node: Node2D, dest_node: Node2D,
		start_direction: Utils.Direction, end_direction: Utils.Direction
) -> Line2D:
	# Find points
	var start_point = source_node.position
	var end_point = dest_node.position
	var turn_points: Array = []
	match start_direction:
		Utils.Direction.LEFT, Utils.Direction.RIGHT:
			match end_direction:
				Utils.Direction.LEFT, Utils.Direction.RIGHT:
					turn_points = _get_2_orthogonal_midpoints(
							start_point, end_point, false)
				Utils.Direction.UP, Utils.Direction.DOWN:
					var point = _get_orthogonal_midpoint(start_point, end_point, false)
					turn_points.append(point)
		Utils.Direction.UP, Utils.Direction.DOWN:
			match end_direction:
				Utils.Direction.LEFT, Utils.Direction.RIGHT:
					var point = _get_orthogonal_midpoint(start_point, end_point, true)
					turn_points.append(point)
				Utils.Direction.UP, Utils.Direction.DOWN:
					turn_points = _get_2_orthogonal_midpoints(
							start_point, end_point, true)

	# Build line
	var line := Line2D.new()
	if source_node is LevelNode and source_node.is_completed():
		line.width = THICK_CONNECTOR_WIDTH
	else:
		line.width = THIN_CONNECTOR_WIDTH
	line.default_color = CONNECTOR_LINE_COLOR
	line.add_point(start_point)
	for point in turn_points:
		line.add_point(point)
	line.add_point(end_point)

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


#====================================================================
# Boxes
#====================================================================

func _build_box(nodes: Array) -> Line2D:
	assert(nodes.size() > 1)

	var group_box = Line2D.new()
	group_box.closed = true
	group_box.width = BOX_LINE_WIDTH
	group_box.joint_mode = Line2D.LINE_JOINT_ROUND
	group_box.default_color = BOX_COLOR

	var boxes: Array = []
	for node in nodes:
		boxes.append(node.box)
	var rect := Utils.get_combined_control_rect(boxes)
	group_box.add_point(Vector2(rect.position.x - BOX_MARGIN.x * ZOOM_SCALE,
			rect.position.y - BOX_MARGIN.y * ZOOM_SCALE))
	group_box.add_point(Vector2(rect.end.x + BOX_MARGIN.x * ZOOM_SCALE,
			rect.position.y - BOX_MARGIN.y * ZOOM_SCALE))
	group_box.add_point(Vector2(rect.end.x + BOX_MARGIN.x * ZOOM_SCALE,
			rect.end.y + BOX_MARGIN.y * ZOOM_SCALE))
	group_box.add_point(Vector2(rect.position.x - BOX_MARGIN.x * ZOOM_SCALE,
			rect.end.y + BOX_MARGIN.y * ZOOM_SCALE))
	return group_box
