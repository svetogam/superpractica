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

var level: Level:
	set = _do_not_set,
	get = _get_level
var pimnet: Pimnet:
	set = _do_not_set,
	get = _get_pimnet
var task_control: Node:
	set = _do_not_set,
	get = _get_task_control
var event_control: Node:
	set = _do_not_set,
	get = _get_event_control


func _init() -> void:
	add_to_group("level_programs")


func _start() -> void:
	_setup_vars()
	var replacements := _get_instruction_replacements()
	task_control.set_instruction_replacements(replacements)


# Virtual
func _setup_vars() -> void:
	pass


# Virtual
func _get_instruction_replacements() -> Dictionary:
	return {}


func complete_task() -> void:
	task_control.complete_current_task()


func _get_level() -> Level:
	assert(_target != null)
	return _target


func _get_pimnet() -> Pimnet:
	assert(level.pimnet != null)
	return level.pimnet


func _get_task_control() -> Node:
	assert(level.task_control != null)
	return level.task_control


func _get_event_control() -> Node:
	assert(level.event_control != null)
	return level.event_control


static func _do_not_set(_value: Variant) -> void:
	assert(false)
