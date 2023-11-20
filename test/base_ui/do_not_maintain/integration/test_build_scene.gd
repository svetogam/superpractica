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

var WINDOW_PATH := "res://core/base_ui/sp_window/sp_window.tscn"
var SUBSCREEN_VIEWER_PATH :=\
		"res://core/base_ui/sp_window/subscreen_viewer/subscreen_viewer.tscn"
var SUBSCREEN_PATH := "res://core/base_ui/subscreen/subscreen.tscn"
var WindowScene: PackedScene
var SubscreenViewerScene: PackedScene
var SubscreenScene: PackedScene
var got


func before_all():
	super.before_all()
	WindowScene = load(WINDOW_PATH)
	SubscreenViewerScene = load(SUBSCREEN_VIEWER_PATH)
	SubscreenScene = load(SUBSCREEN_PATH)


func test_add_find_and_remove_stuff():
	#Add stuff
	var superscreen = Superscreen.new()
	superscreen.name = "Superscreen"
	add_child(superscreen)

	var superscreen_object = SuperscreenObject.new()
	superscreen_object.name = "SuperscreenObject"
	superscreen.add_child(superscreen_object)

	var window = WindowScene.instantiate()
	window.name = "Window"
	superscreen.add_child(window)

	var window_content = WindowContent.new()
	window_content.name = "WindowContent"
	window.add_content(window_content)

	var subscreen_viewer = SubscreenViewerScene.instantiate()
	subscreen_viewer.name = "SubscreenViewer"
	window.add_content(subscreen_viewer)

	var subscreen = SubscreenScene.instantiate()
	subscreen_viewer.set_subscreen(subscreen)

	var subscreen_object = SubscreenObject.new()
	subscreen_object.name = "SubscreenObject"
	subscreen.add_child(subscreen_object)

	#Find stuff
	got = $Superscreen
	assert_eq(got, superscreen)
	got = $Superscreen.get_object("SuperscreenObject")
	assert_eq(got, superscreen_object)
	got = $Superscreen.get_sp_window("Window")
	assert_eq(got, window)
	got = $Superscreen.get_sp_window("Window").get_content("WindowContent")
	assert_eq(got, window_content)
	got = $Superscreen.get_sp_window("Window").get_content("SubscreenViewer")
	assert_eq(got, subscreen_viewer)
	got = subscreen_viewer.get_subscreen()
	assert_eq(got, subscreen)
	got = subscreen.get_object("SubscreenObject")
	assert_eq(got, subscreen_object)

	#Remove stuff
	subscreen.remove_child(subscreen_object)
	got = subscreen.get_object("SubscreenObject")
	assert_eq(got, null)

	subscreen_viewer.remove_subscreen()
	got = subscreen_viewer.get_subscreen()
	assert_eq(got, null)

	window.remove_content("SubscreenViewer")
	got = $Superscreen.get_sp_window("Window").get_content("SubscreenViewer")
	assert_eq(got, null)

	window.remove_content("WindowContent")
	got = $Superscreen.get_sp_window("Window").get_content("WindowContent")
	assert_eq(got, null)

	superscreen.remove_child(window)
	got = $Superscreen.get_sp_window("Window")
	assert_eq(got, null)

	superscreen.remove_child(superscreen_object)
	got = $Superscreen.get_object("SuperscreenObject")
	assert_eq(got, null)

	remove_child(superscreen)
	got = get_node_or_null("Superscreen")
	assert_eq(got, null)
