##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends FieldObject

onready var slice_prefig := $"%SlicePrefig"


func _on_field_ready() -> void:
	input_shape.set_circle(field.pie_radius)


func set_regions_by_slices(slice_list: Array) -> void:
	_remove_region_objects()

	if slice_list.size() > 0:
		var i = 0
		while i < slice_list.size()-1:
			_add_region_object(slice_list[i], slice_list[i+1])
			i += 1
		_add_region_object(slice_list[i], slice_list[0])


func _add_region_object(bounding_slice_1: FieldObject,
			bounding_slice_2: FieldObject) -> FieldObject:
	var new_region = field.create_object(PieSlicerGlobals.Objects.REGION)
	new_region.position = get_center()
	new_region.setup(bounding_slice_1, bounding_slice_2)
	return new_region


func _remove_region_objects() -> void:
	for region in field.queries.get_region_list():
		region.queue_free()


func get_center() -> Vector2:
	return position


func convert_field_point_to_pie_point(point: Vector2) -> Vector2:
	return point - get_center()


func convert_pie_point_to_field_point(point: Vector2) -> Vector2:
	return point + get_center()
