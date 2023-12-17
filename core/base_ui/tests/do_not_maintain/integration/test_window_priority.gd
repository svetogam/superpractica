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

var window_1: SpWindow
var window_2: SpWindow


func _get_scene_path() -> String:
	return "res://core/base_ui/tests/do_not_maintain/integration/test_window_priority.tscn"


func before_each():
	super()
	window_1 = $Test/Superscreen/Window1
	window_2 = $Test/Superscreen/Window2


func test_last_pressed_window_has_priority():
	watch_signals(window_1)
	watch_signals(window_2)

	simulator.click_left_at($Test/PosWindow1.position)
	simulator.click_left_at($Test/PosOverlap.position)
	simulator.run()
	await simulator.done

	assert_signal_emit_count(window_1, "pressed", 2)
	assert_signal_emit_count(window_2, "pressed", 0)

	simulator.click_left_at($Test/PosWindow2.position)
	simulator.click_left_at($Test/PosOverlap.position)
	simulator.run()
	await simulator.done

	assert_signal_emit_count(window_1, "pressed", 2)
	assert_signal_emit_count(window_2, "pressed", 2)
