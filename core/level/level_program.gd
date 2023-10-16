##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name LevelProgram
extends Mode

var level: Node
var pimnet: Pimnet
var task_control: Node
var event_control: Node


func _init() -> void:
	add_to_group("level_programs")


func _pre_start() -> void:
	level = _target
	pimnet = level.pimnet
	task_control = level.task_control
	event_control = level.event_control

	_setup_vars()
	var replacements = _get_instruction_replacements()
	task_control.set_instruction_replacements(replacements)


#Virtual
func _setup_vars() -> void:
	pass


#Virtual
func _get_instruction_replacements() -> Dictionary:
	return {}


func complete_task() -> void:
	task_control.complete_current_task()
