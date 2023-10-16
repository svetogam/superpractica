##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

#DO NOT MAINTAIN

extends SpLevelTest

var field: Field


func before_each():
	.before_each()
	_load_level("debug_windows", "pie_slicer")
	_load_ref_scene(
		"res://content/basic_fractions/tests/pim_levels/do_not_maintain/pie_slicer_pim_ref.tscn"
	)
	field = pimnet.get_pim_field("PieSlicerPim")


#func test_add_and_remove_slices():
#	simulator.click_left_at($Ref/AddSlice.position)
#	simulator.click_left_at($Ref/PieN.position)
#	simulator.click_left_at($Ref/PieE.position)
#	simulator.click_left_at($Ref/PieSW1.position)
#	simulator.click_left_at($Ref/OffPie.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_normal_slice_list().size(), 3)
#
#	simulator.click_left_at($Ref/RemoveSlice.position)
#	simulator.click_left_at($Ref/PieN.position)
#	simulator.click_left_at($Ref/PieW.position)
#	simulator.click_left_at($Ref/PieSW2.position)
#	simulator.click_left_at($Ref/OffPie.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_normal_slice_list().size(), 1)


func test_hover_prefig():
	simulator.click_left_at($Ref/AddSlice.position)
	simulator.move_to($Ref/OffPie.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_phantom_slice_list().size(), 0)
	assert_eq(field.queries.get_slice_prefig(), null)

	simulator.move_to($Ref/PieN.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_normal_slice_list().size(), 0)
	assert_eq(field.queries.get_phantom_slice_list().size(), 1)
	assert_ne(field.queries.get_slice_prefig(), null)

	var prefig_angle = field.queries.get_slice_prefig().get_angle()
	simulator.click_left_at($Ref/PieN.position)
	simulator.move_to($Ref/OffPie.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_phantom_slice_list().size(), 0)
	assert_eq(field.queries.get_slice_prefig(), null)
	if not field.queries.get_normal_slice_list().empty():
		var slice = field.queries.get_normal_slice_list()[0]
		assert_eq(slice.get_angle(), prefig_angle)
	else:
		fail_test("")


func test_select_and_deselect_regions():
	simulator.click_left_at($Ref/AddSlice.position)
	simulator.click_left_at($Ref/PieN.position)
	simulator.click_left_at($Ref/PieSE.position)
	simulator.click_left_at($Ref/PieSW1.position)
	simulator.click_left_at($Ref/SelectRegion.position)
	simulator.click_left_at($Ref/PieE.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_selected_region_list().size(), 1)
	assert_eq(field.queries.get_unselected_region_list().size(), 2)

	simulator.click_left_at($Ref/PieSW2.position)
	simulator.click_left_at($Ref/PieW.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_selected_region_list().size(), 3)
	assert_eq(field.queries.get_unselected_region_list().size(), 0)

	simulator.click_left_at($Ref/PieE.position)
	simulator.click_left_at($Ref/PieSW2.position)
	simulator.click_left_at($Ref/PieW.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.queries.get_selected_region_list().size(), 0)
	assert_eq(field.queries.get_unselected_region_list().size(), 3)


func test_count_regions():
	simulator.click_left_at($Ref/AddSlice.position)
	simulator.click_left_at($Ref/PieN.position)
	simulator.click_left_at($Ref/PieSE.position)
	simulator.click_left_at($Ref/PieSW1.position)
	simulator.click_left_at($Ref/CountRegion.position)
	simulator.click_left_at($Ref/PieE.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.counter.get_count(), 1)

	simulator.click_left_at($Ref/PieSW2.position)
	simulator.click_left_at($Ref/PieW.position)
	simulator.run()
	yield(simulator, "done")
	assert_eq(field.counter.get_count(), 3)


#func test_undo_redo_add_slices():
#	simulator.click_left_at($Ref/AddSlice.position)
#	simulator.click_left_at($Ref/PieN.position)
#	simulator.click_left_at($Ref/PieE.position)
#	simulator.click_left_at($Ref/PieSW1.position)
#	simulator.click_left_at($Ref/Undo.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_normal_slice_list().size(), 2)
#
#	simulator.click_left_at($Ref/Undo.position, 5)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_normal_slice_list().size(), 0)
#
#	simulator.click_left_at($Ref/Redo.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_normal_slice_list().size(), 1)
#
#	simulator.click_left_at($Ref/Redo.position, 5)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_normal_slice_list().size(), 3)
#
#
#func test_reset():
#	simulator.click_left_at($Ref/AddSlice.position)
#	simulator.click_left_at($Ref/PieN.position)
#	simulator.click_left_at($Ref/PieE.position)
#	simulator.click_left_at($Ref/PieSW1.position)
#	simulator.click_left_at($Ref/Reset.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_normal_slice_list().size(), 0)
#
#	simulator.click_left_at($Ref/Undo.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_normal_slice_list().size(), 3)
#
#	simulator.click_left_at($Ref/Redo.position)
#	simulator.run()
#	yield(simulator, "done")
#	assert_eq(field.queries.get_normal_slice_list().size(), 0)
