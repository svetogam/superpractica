#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends SpIntegrationTest

var got
var expected
var subscreen_1_path = ("Superscreen/Window1/WindowRect/ContentPanel/"
		+ "ContentContainer/Viewer1/ViewContainer/SubViewport/Subscreen1")
var subscreen_2_path = ("Superscreen/Window2/WindowRect/ContentPanel/"
		+ "ContentContainer/Viewer2/ViewContainer/SubViewport/Subscreen2")


func _get_scene_path() -> String:
	return "res://core/base_ui/tests/do_not_maintain/integration/test_find_objects.tscn"


func test_get_window_list():
	got = $Superscreen.get_window_list()
	expected = [$Superscreen/Window1, $Superscreen/Window2, $Superscreen/Window3,
			$Superscreen/Window4, $Superscreen/Window5]
	assert_eq_deep(got, expected)


func test_get_sp_window():
	got = $Superscreen.get_sp_window("Window1")
	expected = $Superscreen/Window1
	assert_eq(got, expected)

	got = $Superscreen.get_sp_window("Miss")
	expected = null
	assert_eq(got, expected)


func test_get_windows_at_point():
	got = $Superscreen.get_windows_at_point($Superscreen/PointWin1Cont1.position)
	expected = [$Superscreen/Window1]
	assert_eq_deep(got, expected)

	got = $Superscreen.get_windows_at_point($Superscreen/PointMiss.position)
	expected = []
	assert_eq_deep(got, expected)

	got = $Superscreen.get_windows_at_point($Superscreen/PointWin1Win2Overlap.position)
	expected = [$Superscreen/Window1, $Superscreen/Window2]
	assert_eq_deep(got, expected)


func test_get_window_content():
	got = $Superscreen.get_window_content("Window1", "Miss")
	expected = null
	assert_eq(got, expected)

	got = $Superscreen.get_window_content("Miss", "Content1")
	expected = null
	assert_eq(got, expected)

	got = $Superscreen.get_window_content("Window1", "Content1")
	expected = $Superscreen/Window1/WindowRect/ContentPanel/ContentContainer/Content1
	assert_eq(got, expected)


func test_get_top_window_at_point():
	got = $Superscreen.get_top_window_at_point($Superscreen/PointWin1Cont1.position)
	expected = $Superscreen/Window1
	assert_eq(got, expected)

	got = $Superscreen.get_top_window_at_point($Superscreen/PointMiss.position)
	expected = null
	assert_eq(got, expected)

	got = $Superscreen.get_top_window_at_point($Superscreen/PointWin1Win2Overlap.position)
	expected = $Superscreen/Window2
	assert_eq(got, expected)


func test_get_subscreen_list():
	got = $Superscreen.get_subscreen_list()
	expected = [get_node(subscreen_1_path), get_node(subscreen_2_path)]
	assert_eq_deep(got, expected)


#Test is broken after loading scene in Godot 4
#func test_get_top_subscreen_at_point():
#	got = $Superscreen.get_top_subscreen_at_point($Superscreen/PointWin1Cont1.position)
#	expected = null
#	assert_eq(got, expected)
#
#	got = $Superscreen.get_top_subscreen_at_point($Superscreen/PointMiss.position)
#	expected = null
#	assert_eq(got, expected)
#
#	got = $Superscreen.get_top_subscreen_at_point($Superscreen/PointWin1Subscreen.position)
#	expected = get_node(subscreen_1_path)
#	assert_eq(got, expected)
#
#	got = $Superscreen.get_top_subscreen_at_point($Superscreen/PointWin1Win2Overlap.position)
#	expected = get_node(subscreen_2_path)
#	assert_eq(got, expected)
#
#	got = $Superscreen.get_top_subscreen_at_point($Superscreen/PointWin2Win4Overlap.position)
#	expected = null
#	assert_eq(got, expected)


func test_window_get_content():
	got = $Superscreen/Window1.get_content("Content1")
	expected = $Superscreen/Window1/WindowRect/ContentPanel/ContentContainer/Content1
	assert_eq(got, expected)

	got = $Superscreen/Window1.get_content("Miss")
	expected = null
	assert_eq(got, expected)


#Test is broken after loading scene in Godot 4
#func test_window_get_subscreen_at_point():
#	got = $Superscreen/Window1.get_subscreen_at_point($Superscreen/PointWin1Subscreen.position)
#	expected = get_node(subscreen_1_path)
#	assert_eq(got, expected)
#
#	got = $Superscreen/Window1.get_subscreen_at_point($Superscreen/PointWin1Win2Overlap.position)
#	expected = get_node(subscreen_1_path)
#	assert_eq(got, expected)
#
#	got = $Superscreen/Window1.get_subscreen_at_point($Superscreen/PointMiss.position)
#	expected = null
#	assert_eq(got, expected)


#Test is broken after loading scene in Godot 4
#func test_window_get_content_list_at_point():
#	got = $Superscreen/Window1.get_content_list_at_point($Superscreen/PointWin1Cont1.position)
#	expected = [$Superscreen/Window1/WindowRect/ContentPanel/ContentContainer/Content1]
#	assert_eq(got, expected)
#
#	got = $Superscreen/Window5.get_content_list_at_point($Superscreen/PointWin5.position)
#	expected = [$Superscreen/Window5/WindowRect/ContentPanel/ContentContainer/Content2,
#			$Superscreen/Window5/WindowRect/ContentPanel/ContentContainer/Content2/Content3]
#	assert_eq(got, expected)
#
#	got = $Superscreen/Window1.get_content_list_at_point($Superscreen/PointMiss.position)
#	expected = []
#	assert_eq(got, expected)


func test_subscreen_viewer_get_subscreen():
	got = $Superscreen/Window1/WindowRect/ContentPanel/ContentContainer/Viewer1.get_subscreen()
	expected = get_node(subscreen_1_path)
	assert_eq(got, expected)

	got = $Superscreen/Window4/WindowRect/ContentPanel/ContentContainer/Viewer3.get_subscreen()
	expected = null
	assert_eq(got, expected)
