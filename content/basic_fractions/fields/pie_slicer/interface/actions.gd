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

#####################################################################
# Basic Actions
#####################################################################

func create_slice(vector: Vector2, variant:=PieSlicerGlobals.SliceVariants.NORMAL) -> FieldObject:
	var slice = _field.create_object(PieSlicerGlobals.Objects.SLICE)
	slice.set_variant(variant)
	slice.position = _field.pie.get_center()
	slice.set_vector(vector)
	return slice


func add_slice(point: Vector2, variant:=PieSlicerGlobals.SliceVariants.NORMAL) -> FieldObject:
	if _field.queries.is_pie_point_on_pie(point):
		var slice_vector = _field.queries.make_slice_vector_by_point(point)
		var slice = create_slice(slice_vector, variant)
		_field.update_pie_regions()
		return slice
	return null


func add_equally_spaced_slices(number_slices: int,
			variant:=PieSlicerGlobals.SliceVariants.NORMAL) -> void:
	var angles_list = _field.queries.get_equally_spaced_angles_list(number_slices)
	for angle in angles_list:
		var vector = _field.queries.make_slice_vector_by_angle(angle)
		create_slice(vector, variant)
	_field.update_pie_regions()


func remove_slice(slice: FieldObject) -> void:
	slice.queue_free()
	_field.update_pie_regions()


func remove_slice_at(pie_point: Vector2, distance_limit: float) -> void:
	var slice = _field.queries.get_slice_nearest_to_point(pie_point, distance_limit)
	if slice != null and _field.queries.is_pie_point_on_pie(pie_point):
		remove_slice(slice)


func remove_slices() -> void:
	for slice in _field.queries.get_nonphantom_slice_list():
		slice.queue_free()
	_field.update_pie_regions()


func remove_slice_phantoms() -> void:
	for slice in _field.queries.get_phantom_slice_list():
		slice.queue_free()


func select_region(region: FieldObject) -> void:
	region.toggle_select()


func deselect_regions() -> void:
	for region in _field.queries.get_region_list():
		region.set_selected(false)


func select_contiguous_regions(num_regions: int) -> void:
	for num_region in range(num_regions):
		var region = _field.queries.get_region_by_number(num_region + 1)
		region.toggle_select()


func count_region(region: FieldObject) -> NumberEffect:
	var pie_point = _field.queries.get_center_of_region(region)
	var field_point = _field.pie.convert_pie_point_to_field_point(pie_point)
	return _field.counter.count_next(field_point)


func clear_count() -> void:
	_field.counter.reset_count()


func update_slice_warnings_by_guides() -> void:
	var slices = _field.queries.get_nonphantom_slice_list()
	for slice in slices:
		update_slice_warning_by_guides(slice)


func update_slice_warning_by_guides(slice: FieldObject) -> void:
	if _field.queries.does_slice_follow_guides(slice):
		slice.set_variant(PieSlicerGlobals.SliceVariants.NORMAL)
	else:
		slice.set_variant(PieSlicerGlobals.SliceVariants.WARNING)


#####################################################################
# Field-Setting
#####################################################################

func set_empty_pie() -> void:
	remove_slices()
	clear_count()


func split_pie_into_equal_regions(number_regions: int,
			variant:=PieSlicerGlobals.SliceVariants.NORMAL) -> void:
	remove_slices()
	add_equally_spaced_slices(number_regions, variant)


func set_pie_to_given_number_of_equal_regions_with_given_number_selected(
			total_regions: int, selected_regions: int) -> void:
	split_pie_into_equal_regions(total_regions)
	select_contiguous_regions(selected_regions)
