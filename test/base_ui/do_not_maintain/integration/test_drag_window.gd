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


func _get_scene_path() -> String:
	return "res://test/base_ui/do_not_maintain/integration/test_drag_window.tscn"


func test_drag_window():
	var window = $Test/Superscreen/Window
	var initial_position = window.position

	simulator.drag_left_between($Test/DragStartPos.position, $Test/DragEndPos.position)
	simulator.run()
	yield(simulator, "done")
	var final_position = window.position
	var expected_relative = $Test/DragEndPos.position - $Test/DragStartPos.position
	assert_almost_eq(final_position, initial_position + expected_relative, Vector2(1, 1))

	simulator.move_to($Test/NonDragEndPos.position)
	simulator.run()
	yield(simulator, "done")
	assert_almost_eq(window.position, final_position, Vector2(1, 1))
