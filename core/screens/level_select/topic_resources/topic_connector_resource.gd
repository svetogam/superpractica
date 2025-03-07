# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicConnectorResource
extends Resource

@export var source_node_id: String
@export var dest_node_id: String
@export var start_direction: Utils.Direction = Utils.Direction.RIGHT
@export var end_direction: Utils.Direction = Utils.Direction.RIGHT


func _init(p_source_node_id := "", p_dest_node_id := "",
		p_start_direction: Utils.Direction = Utils.Direction.RIGHT,
		p_end_direction: Utils.Direction = Utils.Direction.RIGHT
) -> void:
	source_node_id = p_source_node_id
	dest_node_id = p_dest_node_id
	start_direction = p_start_direction
	end_direction = p_end_direction
