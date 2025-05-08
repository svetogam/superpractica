# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicGroupResource
extends Resource

@export var node_ids: Array[String]
@export var icon: LevelResource.TopicIcons


func _init(p_node_ids: Array[String] = [], p_icon := LevelResource.TopicIcons.UNKNOWN
) -> void:
	node_ids = p_node_ids
	icon = p_icon


func get_icon_texture() -> Texture2D:
	return LevelResource.get_icon_texture_for(icon)
