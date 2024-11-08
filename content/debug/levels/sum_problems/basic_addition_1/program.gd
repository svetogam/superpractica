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

var start_number: int
var count: int
var pim: Pim
var field: Field


func _setup_vars() -> void:
	start_number = Game.current_level.program_vars.new_start_number()
	count = Game.current_level.program_vars.new_count()


func _start() -> void:
	super()

	tool_panel.exclude_all("GridCounting")
	creation_panel.exclude_all("GridCounting")
	pim = pimnet.get_pim()
	field = pim.field

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	return {"start_number": start_number, "count": count}
