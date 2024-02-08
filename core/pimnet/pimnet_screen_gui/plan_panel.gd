#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PanelContainer

const MAX_TASKS: int = 7

var current_task := "":
	set = _set_current_task
var _data: PlanResource
@onready var _tasks: Array = [
	%Task1, %Task2, %Task3, %Task4, %Task5, %Task6, %Task7,
]
@onready var _task_buttons: Array = [
	%Task1Button, %Task2Button, %Task3Button, %Task4Button, %Task5Button,
	%Task6Button, %Task7Button,
]
@onready var _task_checkboxes: Array = [
	%Task1CheckBox, %Task2CheckBox, %Task3CheckBox, %Task4CheckBox, %Task5CheckBox,
	%Task6CheckBox, %Task7CheckBox,
]


func _ready() -> void:
	var task_number: int = 1
	for button in _task_buttons:
		button.pressed.connect(_on_task_button_pressed.bind(task_number))
		task_number += 1


func setup(p_data: PlanResource, replacements := {}) -> void:
	_data = p_data
	_data.set_instruction_replacements(replacements)

	var i: int = 0
	for task in _data.get_tasks():
		_tasks[i].visible = true
		_task_buttons[i].text = task.name_text
		i += 1

	for j in range(i, MAX_TASKS):
		_tasks[j].visible = false

	var initial_task := _data.get_initial_task()
	_set_current_task(initial_task.name_id)


func is_active() -> bool:
	return _data != null


func is_task_completed(task_id: String) -> bool:
	var task_number := _data.get_task_number(task_id)
	var checkbox = _task_checkboxes[task_number - 1]
	return checkbox.button_pressed


func are_all_tasks_completed() -> bool:
	var final_task_id := _data.get_final_task().name_id
	return is_task_completed(final_task_id)


func _set_current_task(task_id: String) -> void:
	current_task = task_id
	var task_number := _data.get_task_number(task_id)
	var button = _task_buttons[task_number - 1]
	button.button_pressed = true
	_show_task_instructions(task_id)


func complete_current_task() -> void:
	var task_number := _data.get_task_number(current_task)
	var checkbox = _task_checkboxes[task_number - 1]
	checkbox.button_pressed = true

	if current_task != _data.get_final_task().name_id:
		var next_task := _data.get_task_by_number(task_number + 1)
		_set_current_task(next_task.name_id)


func _on_task_button_pressed(task_number: int) -> void:
	var task := _data.get_task_by_number(task_number)
	_show_task_instructions(task.name_id)


func _show_task_instructions(task_id: String) -> void:
	var task := _data.get_task_by_name(task_id)
	%TaskInstructions.text = task.get_instructions()
