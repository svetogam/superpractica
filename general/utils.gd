#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

class_name Utils
extends Object

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}


static func pack_args(arg1: Variant = "__",
		arg2: Variant = "__",
		arg3: Variant = "__",
		arg4: Variant = "__",
		arg5: Variant = "__",
		arg6: Variant = "__",
		arg7: Variant = "__",
		arg8: Variant = "__"
) -> Array:
	var args: Array = [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8]
	return args.filter(func(a): return str(a) != "__")


static func call_callables(callable_list: Array, args: Array = []) -> Array:
	var result_list: Array = []
	for callable in callable_list:
		assert(callable is Callable)
		var result = callable.callv(args)
		result_list.append(result)
	return result_list


static func are_unsorted_lists_equal(list_1: Array, list_2: Array,
		check_function := (func(a, b): return a == b)
) -> bool:
	var first_count: int = 0
	for item_1 in list_1:
		for item_2 in list_2:
			if check_function.call(item_1, item_2):
				first_count += 1
				break

	var second_count: int = 0
	for item_2 in list_2:
		for item_1 in list_1:
			if check_function.call(item_1, item_2):
				second_count += 1
				break

	return (len(list_1) == len(list_2) and len(list_1) == first_count
			and first_count == second_count)


static func are_vectors_equal(vector_1: Vector2, vector_2: Vector2) -> bool:
	return vector_1.is_equal_approx(vector_2)


static func sort_node2d_by_x_position(a: Node2D, b: Node2D) -> bool:
	return a.position.x <= b.position.x


static func get_children_in_group(parent: Node, group: String, recursive := true
) -> Array:
	var children_in_group: Array = []
	if recursive:
		for node in parent.get_tree().get_nodes_in_group(group):
			if parent.is_ancestor_of(node):
				children_in_group.append(node)
	else:
		for child in parent.get_children():
			if child.is_in_group(group):
				children_in_group.append(child)
	return children_in_group


static func convert_from_layer_to_layer(vector: Vector2,
		source: CanvasLayer = null, dest: CanvasLayer = null
) -> Vector2:
	var source_offset := Vector2.ZERO
	var source_scale := Vector2.ONE
	var dest_offset := Vector2.ZERO
	var dest_scale := Vector2.ONE
	if source != null:
		source_offset = source.offset
		source_scale = source.scale
	if dest != null:
		dest_offset = dest.offset
		dest_scale = dest.scale

	var offset_diff := source_offset - dest_offset
	var scale_diff := source_scale / dest_scale
	return (vector + offset_diff) * scale_diff


static func reparent_out_of_sub_viewport(child: Node, new_parent: Node) -> void:
	# Out of viewport
	var viewport = child.get_viewport()
	assert(viewport is SubViewport)
	var viewport_container = viewport.get_parent()
	assert(viewport_container is SubViewportContainer)
	child.global_position += viewport_container.global_position

	# To new parent
	var old_parent = child.get_parent()
	child.reparent(new_parent, false)
	if old_parent is Node2D or old_parent is Control:
		child.global_position -= old_parent.global_position
	if new_parent is Node2D or new_parent is Control:
		child.global_position += new_parent.global_position


static func get_combined_control_rect(control_nodes: Array) -> Rect2:
	assert(control_nodes.size() > 0)

	var max_left: float = control_nodes[0].get_global_rect().position.x
	var max_right: float = control_nodes[0].get_global_rect().end.x
	var max_top: float = control_nodes[0].get_global_rect().position.y
	var max_bottom: float = control_nodes[0].get_global_rect().end.y
	for node in control_nodes:
		if node.get_global_rect().position.x < max_left:
			max_left = node.get_global_rect().position.x
		if node.get_global_rect().end.x > max_right:
			max_right = node.get_global_rect().end.x
		if node.get_global_rect().position.y < max_top:
			max_top = node.get_global_rect().position.y
		if node.get_global_rect().end.y > max_bottom:
			max_bottom = node.get_global_rect().end.y
	return Rect2(max_left, max_top, max_right - max_left, max_bottom - max_top)


static func get_point_at_side(node: Control, side: Side) -> Vector2:
	match side:
		Side.SIDE_LEFT:
			return get_left_point(node)
		Side.SIDE_TOP:
			return get_top_point(node)
		Side.SIDE_RIGHT:
			return get_right_point(node)
		Side.SIDE_BOTTOM:
			return get_bottom_point(node)
		_:
			assert(false)
			return Vector2.ZERO


static func get_left_point(node: Control) -> Vector2:
	return Vector2(node.offset_left, node.get_rect().get_center().y)


static func get_right_point(node: Control) -> Vector2:
	return Vector2(node.offset_right, node.get_rect().get_center().y)


static func get_top_point(node: Control) -> Vector2:
	return Vector2(node.get_rect().get_center().x, node.offset_top)


static func get_bottom_point(node: Control) -> Vector2:
	return Vector2(node.get_rect().get_center().x, node.offset_bottom)


static func side_to_vector(side: Side) -> Vector2:
	match side:
		Side.SIDE_LEFT:
			return Vector2.LEFT
		Side.SIDE_TOP:
			return Vector2.UP
		Side.SIDE_RIGHT:
			return Vector2.RIGHT
		Side.SIDE_BOTTOM:
			return Vector2.DOWN
		_:
			assert(false)
			return Vector2.ZERO
