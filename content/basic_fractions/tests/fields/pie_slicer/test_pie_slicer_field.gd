##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends SpFieldTest


func _get_scene_path() -> String:
	return (
		"res://content/basic_fractions/fields/pie_slicer/pie_slicer_field.tscn"
	)


func before_each():
	.before_each()
	_load_ref_scene(
		"res://content/basic_fractions/tests/fields/pie_slicer/pie_slicer_field_ref.tscn"
	)


func test_add_and_remove_slices():
	field.actions.add_slice($Ref/Offset/PieN.position)
	field.actions.add_slice($Ref/Offset/PieE.position)
	field.actions.add_slice($Ref/Offset/PieSW1.position)
	field.actions.add_slice($Ref/Offset/OffPie.position)
	assert_eq(field.queries.get_normal_slice_list().size(), 3)

	field.actions.remove_slice_at($Ref/Offset/PieN.position, 10.0)
	field.actions.remove_slice_at($Ref/Offset/PieW.position, 10.0)
	field.actions.remove_slice_at($Ref/Offset/PieSW2.position, 10.0)
	field.actions.remove_slice_at($Ref/Offset/OffPie.position, 10.0)
	assert_eq(field.queries.get_normal_slice_list().size(), 1)


func test_select_and_deselect_regions():
	field.actions.add_slice($Ref/Offset/PieN.position)
	field.actions.add_slice($Ref/Offset/PieSE.position)
	field.actions.add_slice($Ref/Offset/PieSW1.position)
	var regions = field.queries.get_region_list()

	field.actions.select_region(regions[0])
	assert_eq(field.queries.get_selected_region_list().size(), 1)
	assert_eq(field.queries.get_unselected_region_list().size(), 2)

	field.actions.select_region(regions[1])
	field.actions.select_region(regions[2])
	assert_eq(field.queries.get_selected_region_list().size(), 3)
	assert_eq(field.queries.get_unselected_region_list().size(), 0)

	field.actions.select_region(regions[0])
	field.actions.select_region(regions[1])
	field.actions.select_region(regions[2])
	assert_eq(field.queries.get_selected_region_list().size(), 0)
	assert_eq(field.queries.get_unselected_region_list().size(), 3)


func test_count_regions():
	field.actions.add_slice($Ref/Offset/PieN.position)
	field.actions.add_slice($Ref/Offset/PieSE.position)
	field.actions.add_slice($Ref/Offset/PieSW1.position)
	var regions = field.queries.get_region_list()
	field.actions.count_region(regions[0])
	assert_eq(field.counter.get_count(), 1)

	field.actions.count_region(regions[1])
	field.actions.count_region(regions[2])
	assert_eq(field.counter.get_count(), 3)


func test_undo_redo_add_slices():
	var mem_states = []
	field.actions.add_slice($Ref/Offset/PieN.position)
	mem_states.append(field.build_mem_state())
	field.actions.add_slice($Ref/Offset/PieSE.position)
	mem_states.append(field.build_mem_state())
	field.actions.add_slice($Ref/Offset/PieSW1.position)
	mem_states.append(field.build_mem_state())

	field.load_mem_state(mem_states[0])
	assert_eq(field.queries.get_normal_slice_list().size(), 1)

	field.load_mem_state(mem_states[2])
	assert_eq(field.queries.get_normal_slice_list().size(), 3)

	field.load_mem_state(mem_states[1])
	assert_eq(field.queries.get_normal_slice_list().size(), 2)


func test_set_empty_pie():
	field.actions.add_slice($Ref/Offset/PieN.position)
	field.actions.add_slice($Ref/Offset/PieSE.position)
	field.actions.add_slice($Ref/Offset/PieSW1.position)
	field.actions.set_empty_pie()
	assert_eq(field.queries.get_normal_slice_list().size(), 0)
