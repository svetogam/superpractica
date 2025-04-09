# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicMap
extends Node

signal node_pressed(node)

# These are duplicates for now
const ZOOM_SCALE := 10.0 # Should equal 1 / ScrollCamera.zoom
const ZOOM_IN_DURATION := 0.5
const ZOOM_OUT_DURATION := 0.35
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
var zoom_scale: float
var focused_node: Control
var _node_ids_to_nodes: Dictionary
@onready var camera_point := %CameraPoint as Node2D
@onready var scroll_camera := %ScrollCamera as Camera2D
@onready var focus_camera := %FocusCamera as Camera2D
@onready var transition_camera := %TransitionCamera as Camera2D
@onready var thumbnail_camera := %ThumbnailCamera as Camera2D
@onready var survey_camera := %SurveyCamera as Camera2D


func build(p_topic_data: TopicResource, p_zoom_scale: float) -> void:
	assert(topic_data == null)
	topic_data = p_topic_data
	zoom_scale = p_zoom_scale

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
		node.position = topic_data.get_node_position(node.id) * zoom_scale
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


func show_node_detail(node_id: String, survey_texture: ViewportTexture = null) -> void:
	focused_node = _node_ids_to_nodes[node_id]
	focused_node.mask.hide()
	focused_node.overview_panel.show()
	if focused_node is SubtopicNode:
		assert(survey_texture != null)
		focused_node.thumbnail.texture = survey_texture


func hide_node_detail() -> void:
	if focused_node != null:
		focused_node.mask.show()
		focused_node.overview_panel.hide()
		focused_node = null


func set_active_camera(next_camera: Camera2D) -> void:
	scroll_camera.enabled = false
	focus_camera.enabled = false
	transition_camera.enabled = false
	thumbnail_camera.enabled = false
	survey_camera.enabled = false

	next_camera.enabled = true


func transition_to_camera(next_camera: Camera2D, duration: float, callback := Callable()
) -> void:
	var previous_camera = get_viewport().get_camera_2d()
	set_active_camera(transition_camera)

	# Prepare transition camera
	if previous_camera != null:
		transition_camera.global_position = previous_camera.global_position
		transition_camera.offset = previous_camera.offset
		transition_camera.zoom = previous_camera.zoom

	var tween = (create_tween()
		.set_trans(Tween.TRANS_QUART)
		.set_ease(Tween.EASE_OUT)
		.tween_property(
			transition_camera,
			"global_position",
			next_camera.global_position,
			duration
		)
	)
	(create_tween()
		.set_trans(Tween.TRANS_QUART)
		.set_ease(Tween.EASE_OUT)
		.tween_property(
			transition_camera,
			"offset",
			next_camera.offset,
			duration
		)
	)
	(create_tween()
		.set_trans(Tween.TRANS_QUAD)
		.set_ease(Tween.EASE_IN_OUT)
		.tween_property(
			transition_camera,
			"zoom",
			next_camera.zoom,
			duration
		)
	)
	tween.finished.connect(set_active_camera.bind(next_camera))
	if not callback.is_null():
		tween.finished.connect(callback)


func update_survey_camera() -> void:
	var viewport_size = get_viewport().get_visible_rect().size
	var camera_survey_rect := get_map_rect().grow_individual(
			CAMERA_SURVEY_MARGIN.x, CAMERA_SURVEY_MARGIN.y,
			CAMERA_SURVEY_MARGIN.x, CAMERA_SURVEY_MARGIN.y)
	var stretched_zoom = viewport_size / camera_survey_rect.size
	var zoom_value = min(stretched_zoom.x, stretched_zoom.y)
	survey_camera.zoom = Vector2(zoom_value, zoom_value)
	survey_camera.position = camera_survey_rect.get_center()


func update_thumbnail_camera() -> void:
	assert(focused_node is LevelNode or focused_node is SubtopicNode)

	var level_texture_rect = focused_node.get_thumbnail_rect()
	thumbnail_camera.global_position = level_texture_rect.get_center()
	thumbnail_camera.zoom = Vector2(
		get_viewport().get_visible_rect().size.x / level_texture_rect.size.x,
		get_viewport().get_visible_rect().size.y / level_texture_rect.size.y
	)


func focus_on_node_id(node_id: String) -> void:
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
	line.width = CONNECTOR_LINE_WIDTH * zoom_scale
	line.default_color = CONNECTOR_LINE_COLOR
	line.add_point(start_point)
	for point in turn_points:
		line.add_point(point)
	var arrowhead_direction = Utils.side_to_vector(end_side) * -1
	var short_end_point = end_point - arrowhead_direction * ARROWHEAD_LENGTH * zoom_scale
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
		Vector2(-ARROWHEAD_LENGTH * zoom_scale, ARROWHEAD_WIDTH * zoom_scale / 2),
		Vector2(-ARROWHEAD_LENGTH * zoom_scale, -ARROWHEAD_WIDTH * zoom_scale / 2)
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
	box.width = BOX_LINE_WIDTH * zoom_scale
	box.joint_mode = Line2D.LINE_JOINT_ROUND
	box.default_color = BOX_COLOR
	box.z_index = -10

	var rect := Utils.get_combined_control_rect(nodes)
	box.add_point(Vector2(rect.position.x - BOX_MARGIN.x * zoom_scale,
			rect.position.y - BOX_MARGIN.y * zoom_scale))
	box.add_point(Vector2(rect.end.x + BOX_MARGIN.x * zoom_scale,
			rect.position.y - BOX_MARGIN.y * zoom_scale))
	box.add_point(Vector2(rect.end.x + BOX_MARGIN.x * zoom_scale,
			rect.end.y + BOX_MARGIN.y * zoom_scale))
	box.add_point(Vector2(rect.position.x - BOX_MARGIN.x * zoom_scale,
			rect.end.y + BOX_MARGIN.y * zoom_scale))
	return box
