# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LevelProgram
extends Node

signal verification_started
signal verification_stopped
signal task_completed(task_name)
signal program_completed
signal program_missed
signal reset_called
signal reset_changed

const START_VERIFYING_DELAY := 0.4
var level: Level  # This should be set by the level
var pimnet: Pimnet:
	get:
		assert(level.pimnet != null)
		return level.pimnet
var overlay: PimnetOverlay:
	get:
		assert(pimnet.overlay != null)
		return pimnet.overlay
var goal_panel: GoalPanel:
	get:
		assert(pimnet.overlay != null)
		assert(pimnet.overlay.goal_panel != null)
		return pimnet.overlay.goal_panel
var verification_panel: PanelContainer:
	get:
		assert(pimnet.overlay != null)
		assert(pimnet.overlay.verification_panel != null)
		return pimnet.overlay.verification_panel
var plan_panel: Control:
	get:
		assert(pimnet.overlay.plan_panel != null)
		return pimnet.overlay.plan_panel
var reverter: CReverter:
	get:
		return level.reverter
var _reset_function := Callable()
var _verifying := false


func _init() -> void:
	add_to_group("level_programs")


func _ready() -> void:
	assert(level.level_data != null)

	if level.level_data.program_plan != null:
		var replacements := _get_instruction_replacements()
		level.level_data.program_plan.set_instruction_replacements(replacements)
		plan_panel.reset()


# Virtual
func _setup_vars(_level_vars: Dictionary) -> void:
	pass


# Virtual
func _get_instruction_replacements() -> Dictionary:
	return {}


func complete_task() -> void:
	if level.level_data.program_plan != null:
		plan_panel.complete_current_task()
		task_completed.emit(plan_panel.current_task)
		if plan_panel.are_all_tasks_completed():
			complete_program()
	else:
		complete_program()


func complete_program() -> void:
	program_completed.emit()
	queue_free()


func miss_program() -> void:
	program_missed.emit()


func start_verifying() -> void:
	assert(not _verifying)

	_verifying = true
	verification_started.emit()


func stop_verifying() -> void:
	assert(_verifying)

	_verifying = false
	verification_stopped.emit()


func is_verifying() -> bool:
	return _verifying


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
