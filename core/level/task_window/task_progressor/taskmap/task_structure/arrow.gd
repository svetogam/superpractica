##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Line2D

@onready var _arrowhead := %Arrowhead as ProceduralGraphic


func set_arrow(source_node: Control, dest_node: Control) -> void:
	var direction = _get_direction_from_node_to_node(source_node, dest_node)
	var start_point
	var mid_point = null
	var end_point
	assert(direction != Vector2(0, 0))

	if direction == Vector2(0, -1):
		start_point = source_node.get_top_point()
		end_point = dest_node.get_bottom_point()
		_set_arrowhead(end_point, "up")
	elif direction == Vector2(0, 1):
		start_point = source_node.get_bottom_point()
		end_point = dest_node.get_top_point()
		_set_arrowhead(end_point, "down")

	elif direction == Vector2(-1, -1):
		start_point = source_node.get_top_point()
		end_point = dest_node.get_right_point()
		mid_point = _get_orthogonal_midpoint(start_point, end_point, true)
		_set_arrowhead(end_point, "left")
	elif direction == Vector2(-1, 1):
		start_point = source_node.get_bottom_point()
		end_point = dest_node.get_right_point()
		mid_point = _get_orthogonal_midpoint(start_point, end_point, true)
		_set_arrowhead(end_point, "left")
	elif direction == Vector2(-1, 0):
		start_point = source_node.get_left_point()
		end_point = dest_node.get_right_point()
		_set_arrowhead(end_point, "left")

	elif direction == Vector2(1, -1):
		start_point = source_node.get_top_point()
		end_point = dest_node.get_left_point()
		mid_point = _get_orthogonal_midpoint(start_point, end_point, true)
		_set_arrowhead(end_point, "right")
	elif direction == Vector2(1, 1):
		start_point = source_node.get_bottom_point()
		end_point = dest_node.get_left_point()
		mid_point = _get_orthogonal_midpoint(start_point, end_point, true)
		_set_arrowhead(end_point, "right")
	elif direction == Vector2(1, 0):
		start_point = source_node.get_right_point()
		end_point = dest_node.get_left_point()
		_set_arrowhead(end_point, "right")

	add_point(start_point)
	if mid_point != null:
		add_point(mid_point)
	add_point(end_point)


func _get_direction_from_node_to_node(node_1: BaseButton, node_2: BaseButton) -> Vector2:
	var direction = Vector2(0, 0)

	if node_1.get_right_point().x < node_2.get_left_point().x:
		direction.x = 1
	elif node_1.get_left_point().x > node_2.get_right_point().x:
		direction.x = -1

	if node_1.get_bottom_point().y < node_2.get_top_point().y:
		direction.y = 1
	elif node_1.get_top_point().y > node_2.get_bottom_point().y:
		direction.y = -1

	return direction


func _get_orthogonal_midpoint(point_1: Vector2, point_2: Vector2, vertical_first: bool) -> Vector2:
	if vertical_first:
		return Vector2(point_1.x, point_2.y)
	else:
		return Vector2(point_2.x, point_1.y)


func _set_arrowhead(tip_point: Vector2, direction: String) -> void:
	_arrowhead.set_properties({"tip_point": tip_point, "direction": direction})
