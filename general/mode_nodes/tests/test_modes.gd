#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

extends GutTest

const ContextScene := preload("a_context.tscn")
var context: Node
var mode_group: ModeGroup
var ungrouped_mode_1: Mode
var ungrouped_mode_2: Mode
var group_mode_1_name: String
var group_mode_2_name: String
var group_mode_3_name: String


func before_each() -> void:
	context = ContextScene.instantiate()
	add_child(context)
	mode_group = $Context/ModeGroup
	ungrouped_mode_1 = $Context/Mode1
	ungrouped_mode_2 = $Context/Mode2
	group_mode_1_name = $Context/ModeGroup/GroupMode1.name
	group_mode_2_name = $Context/ModeGroup/GroupMode2.name
	group_mode_3_name = $Context/ModeGroup/GroupMode3.name


func after_each() -> void:
	context.free()


func test_virtual_methods_called_on_run_and_stop_mode() -> void:
	assert_true(ungrouped_mode_1.started_value != context.started_value)
	assert_true(ungrouped_mode_1.ended_value != context.ended_value)

	ungrouped_mode_1.run()
	assert_true(ungrouped_mode_1.started_value == context.started_value)
	assert_true(ungrouped_mode_1.ended_value != context.ended_value)

	ungrouped_mode_1.stop()
	assert_true(ungrouped_mode_1.started_value == context.started_value)
	assert_true(ungrouped_mode_1.ended_value == context.ended_value)


func test_signals_signals_emitted_on_run_and_stop_mode() -> void:
	watch_signals(ungrouped_mode_1)
	ungrouped_mode_1.run()
	assert_signal_emitted(ungrouped_mode_1, "started")
	assert_signal_not_emitted(ungrouped_mode_1, "stopped")

	ungrouped_mode_1.stop()
	assert_signal_emitted(ungrouped_mode_1, "stopped")


func test_check_mode_is_running() -> void:
	assert_true(not ungrouped_mode_1.is_running())

	ungrouped_mode_1.run()
	assert_true(ungrouped_mode_1.is_running())

	ungrouped_mode_1.stop()
	assert_true(not ungrouped_mode_1.is_running())

	ungrouped_mode_1.run()
	assert_true(ungrouped_mode_1.is_running())


func test_auto_run_and_stop_mode() -> void:
	watch_signals(ungrouped_mode_2)
	assert_true(ungrouped_mode_2.started_value == context.started_value)
	assert_true(ungrouped_mode_2.ended_value != context.ended_value)
	assert_true(ungrouped_mode_2.is_running())

	ungrouped_mode_2.stop()
	assert_true(ungrouped_mode_2.started_value == context.started_value)
	assert_true(ungrouped_mode_2.ended_value == context.ended_value)
	assert_true(not ungrouped_mode_2.is_running())
	assert_signal_emitted(ungrouped_mode_2, "stopped")


func test_mode_group_runs_and_stops_modes() -> void:
	var mode := mode_group.get_mode(group_mode_1_name)
	assert_true(mode.started_value != context.started_value)
	assert_true(mode.ended_value != context.ended_value)
	assert_true(not mode_group.is_active(group_mode_1_name))

	mode_group.activate(group_mode_1_name)
	assert_true(mode.started_value == context.started_value)
	assert_true(mode.ended_value != context.ended_value)
	assert_true(mode_group.is_active(group_mode_1_name))

	mode_group.deactivate(group_mode_1_name)
	assert_true(mode.started_value == context.started_value)
	assert_true(mode.ended_value == context.ended_value)
	assert_true(not mode_group.is_active(group_mode_1_name))


func test_mode_group_emits_signals_on_start_and_stop() -> void:
	watch_signals(mode_group)
	mode_group.activate(group_mode_1_name)
	assert_signal_emitted_with_parameters(
			mode_group, "mode_started", [group_mode_1_name])
	assert_signal_not_emitted(mode_group, "mode_stopped")

	mode_group.activate(group_mode_2_name)
	assert_signal_emitted_with_parameters(
			mode_group, "mode_started", [group_mode_2_name])
	assert_signal_not_emitted(mode_group, "mode_stopped")

	mode_group.deactivate(group_mode_2_name)
	assert_signal_emitted_with_parameters(
			mode_group, "mode_stopped", [group_mode_2_name])

	mode_group.deactivate(group_mode_1_name)
	assert_signal_emitted_with_parameters(
			mode_group, "mode_stopped", [group_mode_1_name])


func test_activate_and_deactivate_modes_together_in_group() -> void:
	mode_group.activate_all()
	assert_true(mode_group.is_active(group_mode_1_name))
	assert_true(mode_group.is_active(group_mode_2_name))

	mode_group.deactivate_all()
	assert_true(not mode_group.is_active(group_mode_1_name))
	assert_true(not mode_group.is_active(group_mode_2_name))


func test_activate_and_deactivate_modes_in_group() -> void:
	mode_group.activate(group_mode_1_name)
	assert_true(mode_group.is_active(group_mode_1_name))
	assert_true(not mode_group.is_active(group_mode_2_name))

	mode_group.activate(group_mode_2_name)
	assert_true(mode_group.is_active(group_mode_1_name))
	assert_true(mode_group.is_active(group_mode_2_name))

	mode_group.deactivate(group_mode_1_name)
	assert_true(not mode_group.is_active(group_mode_1_name))
	assert_true(mode_group.is_active(group_mode_2_name))


func test_activate_only_modes_in_group() -> void:
	mode_group.activate_only(group_mode_1_name)
	assert_true(mode_group.is_active(group_mode_1_name))
	assert_true(not mode_group.is_active(group_mode_2_name))

	mode_group.activate_only(group_mode_2_name)
	assert_true(not mode_group.is_active(group_mode_1_name))
	assert_true(mode_group.is_active(group_mode_2_name))

	mode_group.activate_only(group_mode_1_name)
	assert_true(mode_group.is_active(group_mode_1_name))
	assert_true(not mode_group.is_active(group_mode_2_name))


func test_get_only_active_mode() -> void:
	mode_group.deactivate_all()
	assert_true(mode_group.get_only_active_mode() == null)

	mode_group.activate(group_mode_1_name)
	assert_true(mode_group.get_only_active_mode().name == group_mode_1_name)

	mode_group.activate(group_mode_2_name)
	assert_true(mode_group.get_only_active_mode() == null)


func test_get_mode_names() -> void:
	var got := mode_group.get_mode_names()
	assert_true(got.has(group_mode_1_name))
	assert_true(got.has(group_mode_2_name))
	assert_true(got.has(group_mode_3_name))
	assert_true(got.size() == 3)


func test_get_active_mode_names() -> void:
	var got := mode_group.get_active_mode_names()
	assert_true(got.has(group_mode_3_name))
	assert_true(got.size() == 1)

	mode_group.activate(group_mode_1_name)
	got = mode_group.get_active_mode_names()
	assert_true(got.has(group_mode_1_name))
	assert_true(got.has(group_mode_3_name))
	assert_true(got.size() == 2)

	mode_group.activate(group_mode_2_name)
	got = mode_group.get_active_mode_names()
	assert_true(got.has(group_mode_1_name))
	assert_true(got.has(group_mode_2_name))
	assert_true(got.has(group_mode_3_name))
	assert_true(got.size() == 3)

	mode_group.deactivate(group_mode_1_name)
	got = mode_group.get_active_mode_names()
	assert_true(got.has(group_mode_2_name))
	assert_true(got.has(group_mode_3_name))
	assert_true(got.size() == 2)


func test_is_any_active() -> void:
	assert_true(mode_group.is_any_active())

	mode_group.deactivate(group_mode_3_name)
	assert_true(not mode_group.is_any_active())

	mode_group.activate_all()
	assert_true(mode_group.is_any_active())


func test_set_by_list() -> void:
	var list: Array = [group_mode_1_name, group_mode_2_name]
	mode_group.set_by_list(list)
	var got := mode_group.get_active_mode_names()
	assert_true(got.has(group_mode_1_name))
	assert_true(got.has(group_mode_2_name))
	assert_true(got.size() == 2)

	mode_group.activate_all()
	mode_group.set_by_list(list)
	got = mode_group.get_active_mode_names()
	assert_true(got.has(group_mode_1_name))
	assert_true(got.has(group_mode_2_name))
	assert_true(got.size() == 2)


func test_set_by_dict() -> void:
	var dict := {group_mode_1_name: true, group_mode_2_name: false}
	mode_group.set_by_dict(dict)
	var got := mode_group.get_active_mode_names()
	assert_true(got.has(group_mode_1_name))
	assert_true(got.has(group_mode_3_name))
	assert_true(got.size() == 2)

	mode_group.deactivate_all()
	mode_group.set_by_dict(dict)
	got = mode_group.get_active_mode_names()
	assert_true(got.has(group_mode_1_name))
	assert_true(got.size() == 1)
