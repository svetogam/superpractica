#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends LevelProgram

@export var start_number: int
@export var count: int
@export var _random_start_number: bool
@export var _min_start_number: int
@export var _max_start_number: int
@export var _random_count: bool
@export var _min_count: int
@export var _max_count: int

var pim: Pim
var field: Field


func _setup_vars() -> void:
	start_number = Utils.eval_given_or_random_int(start_number,
			_random_start_number, _min_start_number, _max_start_number)
	count = Utils.eval_given_or_random_int(count, _random_count, _min_count, _max_count)


func _start() -> void:
	super()

	tool_panel.exclude_all("CountingBoard")
	creation_panel.exclude_all("CountingBoard")
	pim = pimnet.get_pim()
	field = pim.field

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	return {"start_number": start_number, "count": count}
