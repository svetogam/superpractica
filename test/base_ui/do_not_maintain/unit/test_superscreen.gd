##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends GutTest

const NUMBER_MOCKS = 3
const WindowScene = preload("res://core/base_ui/window/window.tscn")
var utils := TestingUtils.new(self)
var superscreen: Superscreen
var windows: Array
var got
var expected


func before_each():
	superscreen = Superscreen.new()
	windows = utils.mock_objects_from_scene(WindowScene, NUMBER_MOCKS)


func after_each():
	utils.clear_mocks()


func _setup_superscreen():
	add_child(superscreen)
	for window in windows:
		superscreen.add_child(window)


func test_initializes_properties():
	assert_true(superscreen.rect_clip_content == true)
	assert_true(superscreen.size_flags_horizontal == superscreen.SIZE_EXPAND_FILL)
	assert_true(superscreen.size_flags_vertical == superscreen.SIZE_EXPAND_FILL)
	assert_true(superscreen.anchor_right == superscreen.ANCHOR_END)
	assert_true(superscreen.anchor_bottom == superscreen.ANCHOR_END)
	assert_true(superscreen.is_in_group("superscreens"))


func test_set_offset():
	var initial_position = Vector2(50, 50)
	var offset = Vector2(100, 100)
	var expected_position = initial_position + offset

	var node = Node2D.new()
	node.position = initial_position
	var control = Control.new()
	control.rect_position = initial_position
	superscreen.add_child(node)
	superscreen.add_child(control)

	superscreen.set_offset(offset)
	assert_eq(node.position, expected_position)
	assert_eq(control.rect_position, expected_position)


func test_get_windows_at_point():
	stub(windows[0], "has_point").to_return(true)
	stub(windows[1], "has_point").to_return(true)
	stub(windows[2], "has_point").to_return(false)
	_setup_superscreen()

	got = superscreen.get_windows_at_point(Vector2.ZERO)
	expected = [windows[0], windows[1]]
	assert_eq_deep(got, expected)


func test_get_window_content():
	stub(windows[0], "get_content").to_return("return")
	_setup_superscreen()
	windows[0].name = "name"

	got = superscreen.get_window_content("name", "x")
	assert_eq(got, "return")
	got = superscreen.get_window_content("x", "x")
	assert_null(got)


func test_get_top_window_at_point():
	_setup_superscreen()

	stub(windows[0], "has_point").to_return(false)
	stub(windows[1], "has_point").to_return(false)
	stub(windows[2], "has_point").to_return(false)
	got = superscreen.get_top_window_at_point(Vector2.ZERO)
	assert_null(got)

	stub(windows[0], "has_point").to_return(true)
	stub(windows[1], "has_point").to_return(true)
	stub(windows[2], "has_point").to_return(false)
	stub(windows[0], "has_input_priority_over_other").to_return(false)
	stub(windows[1], "has_input_priority_over_other").to_return(true)
	stub(windows[2], "has_input_priority_over_other").to_return(false)
	got = superscreen.get_top_window_at_point(Vector2.ZERO)
	assert_eq(got, windows[1])

	stub(windows[0], "has_input_priority_over_other").to_return(false)
	stub(windows[1], "has_input_priority_over_other").to_return(false)
	stub(windows[2], "has_input_priority_over_other").to_return(false)
	got = superscreen.get_top_window_at_point(Vector2.ZERO)
	assert_eq(got, windows[0])


func test_get_top_subscreen_at_point():
	_setup_superscreen()
	stub(windows[0], "get_subscreen_at_point").to_return("0")
	stub(windows[1], "get_subscreen_at_point").to_return("1")
	stub(windows[2], "get_subscreen_at_point").to_return("2")

	stub(windows[0], "has_point").to_return(false)
	stub(windows[1], "has_point").to_return(false)
	stub(windows[2], "has_point").to_return(false)
	got = superscreen.get_top_subscreen_at_point(Vector2.ZERO)
	assert_null(got)

	stub(windows[0], "has_point").to_return(true)
	stub(windows[1], "has_point").to_return(true)
	stub(windows[2], "has_point").to_return(false)
	stub(windows[0], "has_input_priority_over_other").to_return(false)
	stub(windows[1], "has_input_priority_over_other").to_return(true)
	stub(windows[2], "has_input_priority_over_other").to_return(false)
	got = superscreen.get_top_subscreen_at_point(Vector2.ZERO)
	assert_eq(got, "1")

	stub(windows[0], "has_input_priority_over_other").to_return(false)
	stub(windows[1], "has_input_priority_over_other").to_return(false)
	stub(windows[2], "has_input_priority_over_other").to_return(false)
	got = superscreen.get_top_subscreen_at_point(Vector2.ZERO)
	assert_eq(got, "0")
