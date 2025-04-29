# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicGroupResource
extends Resource

@export var node_ids: Array[String]
@export var icon: LevelResource.LevelIcons


func _init(p_node_ids: Array[String] = [], p_icon := LevelResource.LevelIcons.UNKNOWN
) -> void:
	node_ids = p_node_ids
	icon = p_icon
