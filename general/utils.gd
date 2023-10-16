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
		return resource.instance()
	else:
		assert(false)
		return null


static func filter_list(list: Array, filter_function: FuncRef) -> Array:
	var filtered_list = []
	for item in list:
		var result = filter_function.call_func(item)
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


static func randi_range(min_inclusive: int, max_exclusive: int) -> int:
	if min_inclusive >= max_exclusive - 1:
		return min_inclusive
	else:
		var diff = max_exclusive - min_inclusive
		return (randi() % diff) + min_inclusive


static func eval_given_or_random_int(given: int, random: bool,
			min_value: int, max_value: int) -> int:
	if not random:
		return given
	else:
		return randi_range(min_value, max_value + 1)


func are_unsorted_lists_equal(list_1: Array, list_2: Array, check_funcref: FuncRef =null) -> bool:
	if check_funcref == null:
		check_funcref = funcref(self, "_is_equal")

	var first_count = 0
	for item_1 in list_1:
		for item_2 in list_2:
			if check_funcref.call_func(item_1, item_2):
				first_count += 1
				break

	var second_count = 0
	for item_2 in list_2:
		for item_1 in list_1:
			if check_funcref.call_func(item_1, item_2):
				second_count += 1
				break

	return (len(list_1) == len(list_2) and len(list_1) == first_count
			and first_count == second_count)


static func _is_equal(a, b) -> bool:
	return a == b


static func are_vectors_equal(vector_1: Vector2, vector_2: Vector2) -> bool:
	return vector_1.is_equal_approx(vector_2)


static func are_dicts_equal(dict1: Dictionary, dict2: Dictionary) -> bool:
	return deep_equal(dict1, dict2)


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


func convert_from_viewport_to_viewport(vector: Vector2,
			source: Viewport =null, dest: Viewport = null) -> Vector2:
	if source == null:
		source = get_viewport()
	if dest == null:
		dest = get_viewport()
	var source_container = ContextUtils.get_parent_of_type(source, ViewportContainer)
	var dest_container = ContextUtils.get_parent_of_type(dest, ViewportContainer)

	var source_position = Vector2.ZERO
	var source_scale = 1.0
	var dest_position = Vector2.ZERO
	var dest_scale = 1.0
	if source_container != null:
		source_position = source_container.rect_position
		source_scale = source_container.stretch_shrink
	if dest_container != null:
		dest_position = dest_container.rect_position
		dest_scale = dest_container.stretch_shrink

	var viewport_offset = source_position - dest_position
	var scale_diff = source_scale / dest_scale
	return (vector + viewport_offset) * scale_diff


func save_screenshot(folder_name: String, filename: String) -> void:
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png(folder_name+"/"+filename+".png")


func create_wait_timer(type:="timeout", time:=-1.0) -> WaitTimer:
	assert(WaitTimer.TYPES.has(type))
	var timer
	if type == "timeout":
		timer = WaitTimer.new(type, time)
	elif type == "next_idle":
		timer = WaitTimer.new(type)
	add_child(timer)
	return timer


class WaitTimer:
	extends Timer
	signal completed

	const TYPES = ["timeout", "next_idle"]
	var type
	var time

	func _init(p_type: String, p_time:=1.0) -> void:
		assert(TYPES.has(p_type))
		assert(p_time > 0)
		type = p_type
		time = p_time

	func _enter_tree() -> void:
		if type == "timeout":
			var timer = get_tree().create_timer(time)
			timer.connect("timeout", self, "_trigger_complete")
		elif type == "next_idle":
			get_tree().connect("idle_frame", self, "_trigger_complete")

	func _trigger_complete() -> void:
		emit_signal("completed")
		queue_free()
