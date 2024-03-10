#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name TopicResource
extends Resource

@export var id: String
@export var title: String
@export var _levels: Array[LevelResource]
@export var _subtopics: Array[TopicResource]
@export var _layout: PackedScene
@export var connections: Array[TopicConnectorResource]
@export var groups: Array[TopicGroupResource]
var supertopic: TopicResource
var _layout_data: Dictionary


func _init(p_id := "", p_title := "",
		p_levels: Array[LevelResource] = [],
		p_subtopics: Array[TopicResource] = [],
		p_layout: PackedScene = null,
		p_connections: Array[TopicConnectorResource] = [],
		p_groups: Array[TopicGroupResource] = []
) -> void:
	id = p_id
	title = p_title
	_levels = p_levels
	_subtopics = p_subtopics
	_layout = p_layout
	connections = p_connections
	groups = p_groups

	for level in _levels:
		level.topic = self
	for subtopic in _subtopics:
		subtopic.supertopic = self


func get_subtopic(id_chain: Array) -> TopicResource:
	for subtopic in _subtopics:
		if subtopic.id == id_chain[0]:
			if id_chain.size() == 1:
				return subtopic
			else:
				id_chain.pop_front()
				return get_subtopic(id_chain)
	return null


func get_level(id_chain: Array) -> LevelResource:
	var level_id = id_chain.pop_back()
	if id_chain.is_empty():
		for level in _levels:
			if level.id == level_id:
				return level
		return null
	else:
		var subtopic = get_subtopic(id_chain)
		return subtopic.get_level([level_id])


func get_levels() -> Array:
	return _levels


func get_subtopics() -> Array:
	return _subtopics


func get_node_position(node_id: String) -> Vector2:
	_lazy_build_data_from_scene()
	return _layout_data[node_id]


func get_num_internals() -> int:
	return _levels.size() + _subtopics.size()


func get_num_completed_internals() -> int:
	var count: int = 0
	for level in get_levels():
		if Game.progress_data.is_level_completed(level.id):
			count += 1
	for subtopic in get_subtopics():
		if subtopic.is_completed():
			count += 1
	return count


func is_completed() -> bool:
	return get_num_internals() == get_num_completed_internals()


func _lazy_build_data_from_scene() -> void:
	if _layout_data.size() == 0:
		var layout_root := _layout.instantiate()
		for node in layout_root.get_children():
			_layout_data[node.id] = node.position
		layout_root.free()
