# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends SubViewportContainer

const TopicMapScene := preload("topic_map/topic_map.tscn")
var topic_map: TopicMap
var topic_data: TopicResource:
	get:
		assert(topic_map != null)
		return topic_map.topic_data
@onready var viewport := %TopicMapViewport as SubViewport


func add_topic_map(p_topic_data: TopicResource) -> TopicMap:
	assert(topic_map == null)

	topic_map = TopicMapScene.instantiate()
	viewport.add_child(topic_map)
	topic_map.build(p_topic_data, TopicMap.ZOOM_SCALE)
	return topic_map


func disuse() -> void:
	topic_map.free()
