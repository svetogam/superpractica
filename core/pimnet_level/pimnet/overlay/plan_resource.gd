#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name PlanResource
extends Resource

@export var _tasks: Array[TaskResource]


func set_instruction_replacements(replacements := {}) -> void:
	for task in _tasks:
		task.set_instruction_replacements(replacements)


func get_task_by_number(number: int) -> TaskResource:
	assert(_tasks.size() > 0)
	assert(number <= _tasks.size())
	return _tasks[number - 1]


func get_task_by_name(task_id: String) -> TaskResource:
	assert(_tasks.size() > 0)
	for task in _tasks:
		if task.name_id == task_id:
			return task
	return null


func get_task_number(task_id: String) -> int:
	assert(_tasks.size() > 0)
	var i: int = 1
	for task in _tasks:
		if task.name_id == task_id:
			return i
		i += 1
	return -1


func get_tasks() -> Array[TaskResource]:
	return _tasks


func get_number_of_tasks() -> int:
	return _tasks.size()


func get_initial_task() -> TaskResource:
	assert(_tasks.size() > 0)
	return _tasks[0]


func get_final_task() -> TaskResource:
	assert(_tasks.size() > 0)
	var index: int = _tasks.size() - 1
	return _tasks[index]
