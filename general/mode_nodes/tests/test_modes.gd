# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

extends GdUnitTestSuite

const ContextScene := preload("a_context.tscn")
var context: Node
var mode_group: ModeGroup
var ungrouped_mode_1: Mode
var ungrouped_mode_2: Mode
var group_mode_1_name: String
var group_mode_2_name: String
var group_mode_3_name: String


func before_test() -> void:
	context = ContextScene.instantiate()
	add_child(context)
	mode_group = $Context/ModeGroup
	ungrouped_mode_1 = $Context/Mode1
	ungrouped_mode_2 = $Context/Mode2
	group_mode_1_name = $Context/ModeGroup/GroupMode1.name
	group_mode_2_name = $Context/ModeGroup/GroupMode2.name
	group_mode_3_name = $Context/ModeGroup/GroupMode3.name


func after_test() -> void:
	context.free()


func test_virtual_methods_called_on_run_and_stop_mode() -> void:
	assert_int(ungrouped_mode_1.started_value).is_not_equal(context.started_value)
	assert_int(ungrouped_mode_1.ended_value).is_not_equal(context.ended_value)

	ungrouped_mode_1.run()
	assert_int(ungrouped_mode_1.started_value).is_equal(context.started_value)
	assert_int(ungrouped_mode_1.ended_value).is_not_equal(context.ended_value)

	ungrouped_mode_1.stop()
	assert_int(ungrouped_mode_1.started_value).is_equal(context.started_value)
	assert_int(ungrouped_mode_1.ended_value).is_equal(context.ended_value)


func test_signals_signals_emitted_on_run_and_stop_mode() -> void:
	monitor_signals(ungrouped_mode_1)
	ungrouped_mode_1.run()
	await assert_signal(ungrouped_mode_1).is_emitted("started")

	ungrouped_mode_1.stop()
	await assert_signal(ungrouped_mode_1).is_emitted("stopped")


func test_check_mode_is_running() -> void:
	assert_bool(not ungrouped_mode_1.is_running()).is_true()

	ungrouped_mode_1.run()
	assert_bool(ungrouped_mode_1.is_running()).is_true()

	ungrouped_mode_1.stop()
	assert_bool(not ungrouped_mode_1.is_running()).is_true()

	ungrouped_mode_1.run()
	assert_bool(ungrouped_mode_1.is_running()).is_true()


func test_auto_run_and_stop_mode() -> void:
	monitor_signals(ungrouped_mode_2)
	assert_int(ungrouped_mode_2.started_value).is_equal(context.started_value)
	assert_int(ungrouped_mode_2.ended_value).is_not_equal(context.ended_value)
	assert_bool(ungrouped_mode_2.is_running()).is_true()

	ungrouped_mode_2.stop()
	assert_int(ungrouped_mode_2.started_value).is_equal(context.started_value)
	assert_int(ungrouped_mode_2.ended_value).is_equal(context.ended_value)
	assert_bool(ungrouped_mode_2.is_running()).is_false()
	await assert_signal(ungrouped_mode_2).is_emitted("stopped")


func test_mode_group_runs_and_stops_modes() -> void:
	var mode := mode_group.get_mode(group_mode_1_name)
	assert_int(mode.started_value).is_not_equal(context.started_value)
	assert_int(mode.ended_value).is_not_equal(context.ended_value)
	assert_bool(mode_group.is_active(group_mode_1_name)).is_false()

	mode_group.activate(group_mode_1_name)
	assert_int(mode.started_value).is_equal(context.started_value)
	assert_int(mode.ended_value).is_not_equal(context.ended_value)
	assert_bool(mode_group.is_active(group_mode_1_name)).is_true()

	mode_group.deactivate(group_mode_1_name)
	assert_int(mode.started_value).is_equal(context.started_value)
	assert_int(mode.ended_value).is_equal(context.ended_value)
	assert_bool(mode_group.is_active(group_mode_1_name)).is_false()


func test_mode_group_emits_signals_on_start_and_stop() -> void:
	monitor_signals(mode_group)
	mode_group.activate(group_mode_1_name)
	await assert_signal(mode_group).is_emitted("mode_started", [group_mode_1_name])

	mode_group.activate(group_mode_2_name)
	await assert_signal(mode_group).is_emitted("mode_started", [group_mode_2_name])

	mode_group.deactivate(group_mode_2_name)
	await assert_signal(mode_group).is_emitted("mode_stopped", [group_mode_2_name])

	mode_group.deactivate(group_mode_1_name)
	await assert_signal(mode_group).is_emitted("mode_stopped", [group_mode_1_name])


func test_activate_and_deactivate_modes_together_in_group() -> void:
	mode_group.activate_all()
	assert_bool(mode_group.is_active(group_mode_1_name)).is_true()
	assert_bool(mode_group.is_active(group_mode_2_name)).is_true()

	mode_group.deactivate_all()
	assert_bool(mode_group.is_active(group_mode_1_name)).is_false()
	assert_bool(mode_group.is_active(group_mode_2_name)).is_false()


func test_activate_and_deactivate_modes_in_group() -> void:
	mode_group.activate(group_mode_1_name)
	assert_bool(mode_group.is_active(group_mode_1_name)).is_true()
	assert_bool(mode_group.is_active(group_mode_2_name)).is_false()

	mode_group.activate(group_mode_2_name)
	assert_bool(mode_group.is_active(group_mode_1_name)).is_true()
	assert_bool(mode_group.is_active(group_mode_2_name)).is_true()

	mode_group.deactivate(group_mode_1_name)
	assert_bool(mode_group.is_active(group_mode_1_name)).is_false()
	assert_bool(mode_group.is_active(group_mode_2_name)).is_true()


func test_activate_only_modes_in_group() -> void:
	mode_group.activate_only(group_mode_1_name)
	assert_bool(mode_group.is_active(group_mode_1_name)).is_true()
	assert_bool(mode_group.is_active(group_mode_2_name)).is_false()

	mode_group.activate_only(group_mode_2_name)
	assert_bool(mode_group.is_active(group_mode_1_name)).is_false()
	assert_bool(mode_group.is_active(group_mode_2_name)).is_true()

	mode_group.activate_only(group_mode_1_name)
	assert_bool(mode_group.is_active(group_mode_1_name)).is_true()
	assert_bool(mode_group.is_active(group_mode_2_name)).is_false()


func test_get_only_active_mode() -> void:
	mode_group.deactivate_all()
	assert_object(mode_group.get_only_active_mode()).is_null()

	mode_group.activate(group_mode_1_name)
	assert_str(mode_group.get_only_active_mode().name).is_equal(group_mode_1_name)

	mode_group.activate(group_mode_2_name)
	assert_object(mode_group.get_only_active_mode()).is_null()


func test_get_mode_names() -> void:
	var got := mode_group.get_mode_names()
	assert_array(got).contains_exactly_in_any_order(
			[group_mode_1_name, group_mode_2_name, group_mode_3_name])


func test_get_active_mode_names() -> void:
	var got := mode_group.get_active_mode_names()
	assert_array(got).contains_exactly([group_mode_3_name])

	mode_group.activate(group_mode_1_name)
	got = mode_group.get_active_mode_names()
	assert_array(got).contains_exactly_in_any_order(
			[group_mode_1_name, group_mode_3_name])

	mode_group.activate(group_mode_2_name)
	got = mode_group.get_active_mode_names()
	assert_array(got).contains_exactly_in_any_order(
			[group_mode_1_name, group_mode_2_name, group_mode_3_name])

	mode_group.deactivate(group_mode_1_name)
	got = mode_group.get_active_mode_names()
	assert_array(got).contains_exactly_in_any_order(
			[group_mode_2_name, group_mode_3_name])


func test_is_any_active() -> void:
	assert_bool(mode_group.is_any_active()).is_true()

	mode_group.deactivate(group_mode_3_name)
	assert_bool(mode_group.is_any_active()).is_false()

	mode_group.activate_all()
	assert_bool(mode_group.is_any_active()).is_true()


func test_set_by_list() -> void:
	var list: Array = [group_mode_1_name, group_mode_2_name]
	mode_group.set_by_list(list)
	var got := mode_group.get_active_mode_names()
	assert_array(got).contains_exactly_in_any_order(
			[group_mode_1_name, group_mode_2_name])

	mode_group.activate_all()
	mode_group.set_by_list(list)
	got = mode_group.get_active_mode_names()
	assert_array(got).contains_exactly_in_any_order(
			[group_mode_1_name, group_mode_2_name])


func test_set_by_dict() -> void:
	var dict := {group_mode_1_name: true, group_mode_2_name: false}
	mode_group.set_by_dict(dict)
	var got := mode_group.get_active_mode_names()
	assert_array(got).contains_exactly_in_any_order(
			[group_mode_1_name, group_mode_3_name])

	mode_group.deactivate_all()
	mode_group.set_by_dict(dict)
	got = mode_group.get_active_mode_names()
	assert_array(got).contains_exactly([group_mode_1_name])
