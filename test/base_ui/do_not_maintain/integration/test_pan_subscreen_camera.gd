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

var subscreen: Subscreen


func _get_scene_path() -> String:
	return "res://test/base_ui/do_not_maintain/integration/test_pan_subscreen_camera.tscn"


func before_each():
	.before_each()
	subscreen = get_node("Test/Superscreen/Window/WindowRect/ContentPanel/"\
			+ "ContentContainer/SubscreenViewer/ViewContainer/Viewport/Subscreen")


func test_pan_subscreen_camera():
	var initial_rect = subscreen.get_camera().get_rect()

	simulator.drag_left_between($Test/StartDragPoint.position, $Test/EndDragPoint.position)
	simulator.run()
	yield(simulator, "done")

	var final_rect = subscreen.get_camera().get_rect()
	var expected_drag = $Test/StartDragPoint.position - $Test/EndDragPoint.position
	assert_almost_eq(final_rect.position, initial_rect.position + expected_drag, Vector2(1, 1))
