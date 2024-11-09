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
signal reset_called
signal reset_changed

var level: Level:
	get:
		assert(_target != null)
		return _target
var pimnet: Pimnet:
	get:
		assert(level.pimnet != null)
		return level.pimnet
var overlay: PimnetOverlay:
	get:
		assert(level.pimnet.overlay != null)
		return level.pimnet.overlay
var goal_panel: Control:
	get:
		assert(level.pimnet.overlay.goal_panel != null)
		return level.pimnet.overlay.goal_panel
var plan_panel: Control:
	get:
		assert(level.pimnet.overlay.plan_panel != null)
		return level.pimnet.overlay.plan_panel
var tool_panel: Control:
	get:
		assert(level.pimnet.overlay.tool_panel != null)
		return level.pimnet.overlay.tool_panel
var creation_panel: Control:
	get:
		assert(level.pimnet.overlay.creation_panel != null)
		return level.pimnet.overlay.creation_panel
var reverter: CReverter:
	get:
		return level.reverter
var _reset_function := Callable()


func _init() -> void:
	add_to_group("level_programs")


func _start() -> void:
	assert(Game.current_level != null)

	if Game.current_level.program_vars != null:
		_setup_vars()

	if Game.current_level.program_plan != null:
		var replacements := _get_instruction_replacements()
		Game.current_level.program_plan.set_instruction_replacements(replacements)


# Virtual
func _setup_vars() -> void:
	pass


# Virtual
func _get_instruction_replacements() -> Dictionary:
	return {}


func complete_task() -> void:
	if Game.current_level.program_plan != null:
		plan_panel.complete_current_task()
		task_completed.emit(plan_panel.current_task)
		if plan_panel.are_all_tasks_completed():
			complete_level()
	else:
		complete_level()


func complete_level() -> void:
	level_completed.emit()
	stop()


func reset() -> void:
	if not _reset_function.is_null():
		_reset_function.call()
		reset_called.emit()


func set_no_reset() -> void:
	_reset_function = Callable()
	reset_changed.emit()


func set_custom_reset(callable: Callable) -> void:
	_reset_function = callable
	reset_changed.emit()


func is_reset_possible() -> bool:
	return not _reset_function.is_null()
