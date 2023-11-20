##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends SpIntegrationTest

var viewer: SubscreenViewer
var subscreen: Subscreen
var got
var expected


func _get_scene_path() -> String:
	return "res://test/base_ui/do_not_maintain/integration/test_subscreen_stuff.tscn"


func before_each():
	super.before_each()
	viewer = $Test/Superscreen/Window/WindowRect/ContentPanel/ContentContainer/SubscreenViewer
	subscreen = viewer.get_subscreen()


func test_viewer_convert_points_at_regular_zoom():
	var point_1 = $Test/OverSubscreenPoint1.position
	var point_2 = $Test/OverSubscreenPoint2.position
	var subscreen_point_1 = viewer.convert_external_to_internal_point(point_1)
	var subscreen_point_2 = viewer.convert_external_to_internal_point(point_2)
	assert_almost_eq(point_2 - point_1, subscreen_point_2 - subscreen_point_1, Vector2(0.1, 0.1))

	var back = viewer.convert_internal_to_external_point(subscreen_point_1)
	assert_eq(back, point_1)


func test_viewer_convert_vectors_at_regular_zoom():
	var superscreen_vector = Vector2(2, 2)
	var subscreen_vector = viewer.convert_external_to_internal_vector(superscreen_vector)
	var back = viewer.convert_internal_to_external_vector(subscreen_vector)
	assert_eq(superscreen_vector, subscreen_vector)
	assert_eq(superscreen_vector, back)


func test_subscreen_rect():
	var size = Vector2(100, 100)
	subscreen.set_rect(Vector2.ZERO, size)

	got = subscreen.get_center()
	assert_eq(got, size/2)

	var hit = subscreen.has_point(size/2)
	var miss = subscreen.has_point(size*2)
	assert_eq(hit, true)
	assert_eq(miss, false)
