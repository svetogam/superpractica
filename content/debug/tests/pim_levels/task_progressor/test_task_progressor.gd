##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends SpLevelTest

var taskmap: Subscreen


func before_each():
	.before_each()
	_load_level("debug_windows", "task_progressor")
	_load_ref_scene(
		"res://content/debug/tests/pim_levels/task_progressor/task_progressor_ref.tscn"
	)
	taskmap = get_tree().get_nodes_in_group("task_progressors")[0]._taskmap


func test_select_task_nodes():
	watch_signals(taskmap)

	simulator.click_left_at($Ref/Step2.position)
	simulator.run()
	yield(simulator, "done")
	assert_signal_emitted(taskmap, "task_selected")


func test_pan_camera():
	var initial_rect = taskmap.get_camera().get_rect()
	simulator.drag_left_between($Ref/MissStep.position, $Ref/LeftOfTaskmap.position)
	simulator.run()
	yield(simulator, "done")
	var final_rect = taskmap.get_camera().get_rect()
	assert_gt(final_rect.position.x, initial_rect.position.x + 100)
