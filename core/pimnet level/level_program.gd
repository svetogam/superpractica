#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name LevelProgram
extends Mode

signal task_completed(task_name)
signal level_completed

@export var _plan_data: PlanResource
var level: Level:
	set = _do_not_set,
	get = _get_level
var pimnet: Pimnet:
	set = _do_not_set,
	get = _get_pimnet
var goal_panel: Control:
	set = _do_not_set,
	get = _get_goal_panel
var plan_panel: Control:
	set = _do_not_set,
	get = _get_plan_panel
var tool_panel: Control:
	set = _do_not_set,
	get = _get_tool_panel
var creation_panel: Control:
	set = _do_not_set,
	get = _get_creation_panel


func _init() -> void:
	add_to_group("level_programs")


func _start() -> void:
	_setup_vars()

	if _plan_data != null:
		var replacements := _get_instruction_replacements()
		plan_panel.setup(_plan_data, replacements)


# Virtual
func _setup_vars() -> void:
	pass


# Virtual
func _get_instruction_replacements() -> Dictionary:
	return {}


func complete_task() -> void:
	if plan_panel.is_active():
		plan_panel.complete_current_task()
		task_completed.emit(plan_panel.current_task)
		if plan_panel.are_all_tasks_completed():
			complete_level()
	else:
		complete_level()


func complete_level() -> void:
	if Game.current_level != null:
		Game.progress_data.save_level_completion(Game.current_level.id)
	level.pimnet.overlay.show_completion_popup()
	level_completed.emit()

	stop()


func _get_level() -> Level:
	assert(_target != null)
	return _target


func _get_pimnet() -> Pimnet:
	assert(level.pimnet != null)
	return level.pimnet


func _get_goal_panel() -> Control:
	assert(level.pimnet.overlay != null)
	assert(level.pimnet.overlay.goal_panel != null)
	return level.pimnet.overlay.goal_panel


func _get_plan_panel() -> Control:
	assert(level.pimnet.overlay != null)
	assert(level.pimnet.overlay.plan_panel != null)
	return level.pimnet.overlay.plan_panel


func _get_tool_panel() -> Control:
	assert(level.pimnet.overlay != null)
	assert(level.pimnet.overlay.tool_panel != null)
	return level.pimnet.overlay.tool_panel


func _get_creation_panel() -> Control:
	assert(level.pimnet.overlay != null)
	assert(level.pimnet.overlay.creation_panel != null)
	return level.pimnet.overlay.creation_panel


static func _do_not_set(_value: Variant) -> void:
	assert(false)
