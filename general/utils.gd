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

static func emit_signal_v(p_signal: Signal, args: Array = []) -> void:
	if args.size() == 0:
		p_signal.emit()
	elif args.size() == 1:
		p_signal.emit(args[0])
	elif args.size() == 2:
		p_signal.emit(args[0], args[1])
	elif args.size() == 3:
		p_signal.emit(args[0], args[1], args[2])
	elif args.size() == 4:
		p_signal.emit(args[0], args[1], args[2], args[3])
	elif args.size() == 5:
		p_signal.emit(args[0], args[1], args[2], args[3], args[4])
	elif args.size() == 6:
		p_signal.emit(args[0], args[1], args[2], args[3],args[4], args[5])
	elif args.size() == 7:
		p_signal.emit(args[0], args[1], args[2], args[3],args[4], args[5], args[6])
	elif args.size() == 8:
		p_signal.emit(args[0], args[1], args[2], args[3],args[4], args[5], args[6],
				args[7])
	else:
		assert(false)


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


static func eval_given_or_random_int(given: int, random: bool,
		min_value: int, max_value: int
) -> int:
	if not random:
		return given
	else:
		return randi_range(min_value, max_value)


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


static func is_vector_represented(vector: Vector2, vector_list: Array) -> bool:
	for vector_2 in vector_list:
		if vector_2.is_equal_approx(vector):
			return true
	return false


static func sort_node2d_by_x_position(a: Node2D, b: Node2D) -> bool:
	return a.position.x <= b.position.x


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
