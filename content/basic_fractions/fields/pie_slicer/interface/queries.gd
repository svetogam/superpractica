##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldInterfaceComponent

const PIE_CENTER := Vector2.ZERO

#####################################################################
# Object-Finding
#####################################################################

func get_slice_list() -> Array:
	var slice_list = _field.get_object_list_by_type(PieSlicerGlobals.Objects.SLICE)
	sort_slice_list(slice_list)
	return slice_list


func sort_slice_list(slice_list: Array) -> void:
	slice_list.sort_custom(self, "sort_slices_clockwise_from_top")


static func sort_slices_clockwise_from_top(slice_1, slice_2) -> bool:
	return slice_1.get_angle() < slice_2.get_angle()


func get_slice_prefig() -> FieldObject:
	var prefig = _field.pie.slice_prefig
	if prefig.visible:
		return prefig
	return null


func get_nonphantom_slice_list() -> Array:
	var nonphantom_slice_list = []
	for slice in get_slice_list():
		if not slice.is_phantom():
			nonphantom_slice_list.append(slice)
	return nonphantom_slice_list


func get_region_list() -> Array:
	return _field.get_objects_by_group("pie_regions")


func get_phantom_slice_list() -> Array:
	var phantom_slice_list = []
	for slice in get_slice_list():
		if slice.is_phantom():
			phantom_slice_list.append(slice)
	return phantom_slice_list


func get_normal_slice_list() -> Array:
	var normal_slice_list = []
	for slice in get_nonphantom_slice_list():
		if slice.variant == PieSlicerGlobals.SliceVariants.NORMAL:
			normal_slice_list.append(slice)
	return normal_slice_list


func get_guiding_slice_list() -> Array:
	var guiding_slice_list = []
	for slice in get_phantom_slice_list():
		if slice.variant == PieSlicerGlobals.SliceVariants.GUIDE:
			guiding_slice_list.append(slice)
	return guiding_slice_list


func get_selected_region_list() -> Array:
	var region_list = get_region_list()
	var filter = funcref(self, "_is_object_selected")
	return Utils.filter_list(region_list, filter)


static func _is_object_selected(object: FieldObject) -> bool:
		return object.selected


func get_unselected_region_list() -> Array:
	var unselected_region_list = get_region_list()
	var selected_region_list = get_selected_region_list()
	for selected_region in selected_region_list:
		unselected_region_list.erase(selected_region)
	return unselected_region_list


func get_number_of_selected_regions() -> int:
	return get_selected_region_list().size()


func get_region_by_number(number: int) -> FieldObject:
	var region_list = get_region_list()
	return region_list[number-1]


func get_slice_nearest_to_point(pie_point: Vector2, limit_radius: float,
			slice_list:=[null]) -> FieldObject:
	if slice_list.has(null):
		slice_list = _get_default_slice_list()

	var nearest_slice = null
	var nearest_slice_distance = 0

	for slice in slice_list:
		if slice_intersects_circle(slice.vector, pie_point, limit_radius):
			var slice_distance = pie_point.distance_to(slice.vector)
			if nearest_slice == null or slice_distance < nearest_slice_distance:
				nearest_slice = slice
				nearest_slice_distance = slice_distance

	return nearest_slice


func get_slice_nearest_to_angle(angle: float, slice_list:=[null]) -> FieldObject:
	if slice_list.has(null):
		slice_list = _get_default_slice_list()

	var nearest = null

	for slice in slice_list:
		if nearest == null:
			nearest = slice
			continue

		var slice_diff = get_difference_between_angles(slice.get_angle(), angle)
		var nearest_diff = get_difference_between_angles(nearest.get_angle(), angle)
		if slice_diff < nearest_diff:
			nearest = slice

	return nearest


#This doesn't actually work all the time -- Fix it
func pair_slices_with_nearest_angles(angle_list: Array, slice_list:=[null]) -> Array:
	if slice_list.has(null):
		slice_list = _get_default_slice_list()

	var slice_destination_pair_list = []
	for angle in angle_list:
		var nearest_slice = get_slice_nearest_to_angle(angle, slice_list)
		var slice_destination_pair = [nearest_slice, angle]
		slice_destination_pair_list.append(slice_destination_pair)

	return slice_destination_pair_list


func _get_default_slice_list() -> Array:
	return get_nonphantom_slice_list()


#####################################################################
# Analysis
#####################################################################

func is_point_on_pie(field_point: Vector2) -> bool:
	return _field.pie.has_point(field_point)


#Point is relative to pie center
func is_pie_point_on_pie(pie_point: Vector2) -> bool:
	var field_point = pie_point + _field.pie.global_position
	return is_point_on_pie(field_point)


func make_slice_vector_by_point(point: Vector2) -> Vector2:
	var direction_vector = PIE_CENTER.direction_to(point)
	return direction_vector * _field.pie_radius


func make_slice_vector_by_angle(angle: float) -> Vector2:
	var godot_angle = convert_pie_slicer_angle_to_godot_angle(angle)
	return polar2cartesian(_field.pie_radius, godot_angle)


static func get_angle_of_point(point: Vector2) -> float:
	var direction_vector = PIE_CENTER.direction_to(point)
	var godot_angle = direction_vector.angle()
	return convert_godot_angle_to_pie_slicer_angle(godot_angle)


#The pie-slicer-angle rotates clockwise from the top in radians, from 0 to TAU
static func convert_godot_angle_to_pie_slicer_angle(godot_angle: float) -> float:
	var angle_clockwise_from_left = godot_angle + PI
	var period_offset = 0
	if angle_clockwise_from_left < PI/2:
		period_offset = TAU
	var angle_clockwise_from_top = angle_clockwise_from_left + period_offset - PI/2

	return angle_clockwise_from_top


#The pie-slicer-angle rotates clockwise from the top in radians, from 0 to TAU
static func convert_pie_slicer_angle_to_godot_angle(angle_clockwise_from_top: float) -> float:
	var period_offset = 0
	if angle_clockwise_from_top >= TAU - PI/2:
		period_offset = TAU
	var angle_clockwise_from_left = angle_clockwise_from_top - period_offset + PI/2
	var godot_angle = angle_clockwise_from_left - PI

	return godot_angle


func get_number_of_regions() -> int:
	return get_region_list().size()


static func slice_intersects_circle(slice_endpoint: Vector2, circle_center: Vector2,
			circle_radius: float) -> bool:
	var intersection_point = Geometry.segment_intersects_circle(
			PIE_CENTER, slice_endpoint, circle_center, circle_radius)
	return intersection_point > 0


static func get_difference_between_angles(angle_1: float, angle_2: float) -> float:
	var smaller_angle
	var bigger_angle
	if angle_1 <= angle_2:
		smaller_angle = angle_1
		bigger_angle = angle_2
	else:
		smaller_angle = angle_2
		bigger_angle = angle_1

	if bigger_angle - smaller_angle > PI:
		return smaller_angle + TAU - bigger_angle
	else:
		return bigger_angle - smaller_angle


#Higher tolerance means slices farther away will pass
func is_slice_near_angle(slice: FieldObject, angle: float, tolerance:=1.0) -> bool:
	var error_in_radians_multiple = TAU/16
	var angle_tolerance = tolerance * error_in_radians_multiple

	var angle_difference = get_difference_between_angles(slice.get_angle(), angle)
	if angle_difference <= angle_tolerance:
		return true
	else:
		return false


func is_slice_near_slice(slice: FieldObject, other_slice: FieldObject, tolerance:=1.0) -> bool:
	var angle = other_slice.get_angle()
	return is_slice_near_angle(slice, angle, tolerance)


#Returns true if slice_1 is counter-clockwise from point and slice_2 is clockwise
#Am I assuming that slice_1 is nearer counter_clockwise from slice_2? I should not assume it.
func is_point_between_slices(point: Vector2,
			slice_1: FieldObject, slice_2: FieldObject) -> bool:
	var point_angle = get_angle_of_point(point)

	var angle_1 = slice_1.get_angle()
	var angle_2 = slice_2.get_angle()

	if angle_1 <= angle_2 and (point_angle >= angle_1
							   and point_angle < angle_2):
		return true

	#For the angle-number wrapping around
	elif angle_1 > angle_2 and (point_angle >= angle_1
								or point_angle < angle_2):
		return true

	else:
		return false


func get_center_of_region(region: FieldObject) -> Vector2:
	var mid_vector = get_intermediate_slice_vector(
										region.bounding_slices[0], region.bounding_slices[1])
	var multiple = 2.0/3.0
	return Vector2(mid_vector.x * multiple, mid_vector.y * multiple)


#Returns a slice bisecting the area clockwise from slice_1 and counter-clockwise from slice_2
func get_intermediate_slice_vector(slice_1: FieldObject, slice_2: FieldObject) -> Vector2:
	var angle_1 = slice_1.get_angle()
	var angle_2 = slice_2.get_angle()
	var intermediate_angle = get_intermediate_angle(angle_1, angle_2)
	return make_slice_vector_by_angle(intermediate_angle)


static func get_intermediate_angle(angle_1: float, angle_2: float) -> float:
	#If there is no wrap-around
	if angle_1 < angle_2:
		return (angle_1 + angle_2)/2
	#If there is a wrap-around
	elif angle_1 > angle_2:
		return (angle_1 + angle_2 + TAU)/2 - TAU
	else:
		return angle_1


#Gives angles that divide the pie into number_angles equally sized pieces
static func get_equally_spaced_angles_list(number_angles: int) -> Array:
	var angles_list = []
	if number_angles > 1:
		var angle_increment = TAU / number_angles
		for i in range(number_angles):
			angles_list.append(i * angle_increment)

	return angles_list


func are_slices_equally_spaced_enough(equal_enough_tolerance:=1.0, slice_list:=[null]) -> bool:
	if slice_list.has(null):
		slice_list = _get_default_slice_list()

	var number_slices = slice_list.size()
	var equal_angles = get_equally_spaced_angles_list(number_slices)

	for angle in equal_angles:
		var nearest_slice = get_slice_nearest_to_angle(angle, slice_list)
		if not is_slice_near_angle(nearest_slice, angle, equal_enough_tolerance):
			return false

	return true


func does_slice_follow_guides(slice: FieldObject) -> bool:
	var slice_guides = get_guiding_slice_list()
	var other_slices = get_nonphantom_slice_list()
	other_slices.erase(slice)

	for guide in slice_guides:
		if is_slice_near_slice(slice, guide):
			for other_slice in other_slices:
				if is_slice_near_slice(other_slice, guide)\
							and not other_slice.variant == PieSlicerGlobals.SliceVariants.WARNING:
					#Duplicating a correct slice
					return false
			#Single slice in the right place
			return true
	#Not in the right place
	return false


func do_slices_match_guides() -> bool:
	var slice_guides = get_phantom_slice_list()
	var slices = get_nonphantom_slice_list()

	if slice_guides.size() != slices.size():
		return false

	for slice in slices:
		if not does_slice_follow_guides(slice):
			return false

	return true


#####################################################################
# Memo-Building
#####################################################################
