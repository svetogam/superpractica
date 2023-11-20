##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

extends Node

static func make_node_from_resource(resource: Resource) -> Node:
	if resource is GDScript:
		return resource.new()
	elif resource is PackedScene:
		return resource.instantiate()
	else:
		assert(false)
		return null


static func filter_list(list: Array, filter_function: Callable) -> Array:
	var filtered_list = []
	for item in list:
		var result = filter_function.call(item)
		if result:
			filtered_list.append(item)
	return filtered_list


static func filter_objects_by_group(object_list: Array, group: String) -> Array:
	var group_object_list = []
	for obj in object_list:
		if obj.is_in_group(group):
			group_object_list.append(obj)
	return group_object_list


static func filter_objects_by_visibility(object_list: Array) -> Array:
	var visible_object_list = []
	for object in object_list:
		if object.visible:
			visible_object_list.append(object)
	return visible_object_list


func get_position_in_screen(position: Vector2) -> Vector2:
	assert(position.x >= 0 and position.x <= 1 and position.y >= 0 and position.y <= 1)
	var root_viewport = get_viewport()
	return Vector2(root_viewport.size.x * position.x, root_viewport.size.y * position.y)


static func eval_given_or_random_int(given: int, random: bool,
			min_value: int, max_value: int) -> int:
	if not random:
		return given
	else:
		return randi_range(min_value, max_value)


func are_unsorted_lists_equal(list_1: Array, list_2: Array, check_func:=Callable()) -> bool:
	if check_func.is_null():
		check_func = Callable(self, "_is_equal")

	var first_count = 0
	for item_1 in list_1:
		for item_2 in list_2:
			if check_func.call(item_1, item_2):
				first_count += 1
				break

	var second_count = 0
	for item_2 in list_2:
		for item_1 in list_1:
			if check_func.call(item_1, item_2):
				second_count += 1
				break

	return (len(list_1) == len(list_2) and len(list_1) == first_count
			and first_count == second_count)


static func _is_equal(a, b) -> bool:
	return a == b


static func are_vectors_equal(vector_1: Vector2, vector_2: Vector2) -> bool:
	return vector_1.is_equal_approx(vector_2)


static func is_vector_represented(vector: Vector2, vector_list: Array) -> bool:
	for vector_2 in vector_list:
		if vector_2.is_equal_approx(vector):
			return true
	return false


static func emit_signal_v(object: Object, signal_name: String, args:=[]) -> void:
	if args.size() == 0:
		object.emit_signal(signal_name)
	elif args.size() == 1:
		object.emit_signal(signal_name, args[0])
	elif args.size() == 2:
		object.emit_signal(signal_name, args[0], args[1])
	elif args.size() == 3:
		object.emit_signal(signal_name, args[0], args[1], args[2])
	elif args.size() == 4:
		object.emit_signal(signal_name, args[0], args[1], args[2], args[3])
	elif args.size() == 5:
		object.emit_signal(signal_name, args[0], args[1], args[2], args[3], args[4])
	elif args.size() == 6:
		object.emit_signal(signal_name, args[0], args[1], args[2], args[3], args[4], args[5])
	elif args.size() == 7:
		object.emit_signal(signal_name, args[0], args[1], args[2], args[3], args[4], args[5],
				args[6])
	elif args.size() == 8:
		object.emit_signal(signal_name, args[0], args[1], args[2], args[3], args[4], args[5],
				args[6], args[7])
	else:
		assert(false)


static func sort_node2d_by_x_position(a: Node2D, b: Node2D) -> bool:
	return a.position.x <= b.position.x


static func convert_from_layer_to_layer(vector: Vector2,
			source: CanvasLayer =null, dest: CanvasLayer =null) -> Vector2:
	var source_offset = Vector2.ZERO
	var source_scale = Vector2.ONE
	var dest_offset = Vector2.ZERO
	var dest_scale = Vector2.ONE
	if source != null:
		source_offset = source.offset
		source_scale = source.scale
	if dest != null:
		dest_offset = dest.offset
		dest_scale = dest.scale

	var offset_diff = source_offset - dest_offset
	var scale_diff = source_scale / dest_scale
	return (vector + offset_diff) * scale_diff


func save_screenshot(folder_name: String, filename: String) -> void:
	var image = get_viewport().get_texture().get_image()
	image.save_png(folder_name+"/"+filename+".png")
