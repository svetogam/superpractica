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

var addend_1: int
var addend_2: int
var pim: Pim
var field: Field
var output_program: PimProgram


func _setup_vars() -> void:
	addend_1 = Game.current_level.program_vars.new_addend_1()
	addend_2 = Game.current_level.program_vars.new_addend_2()


func _start() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	goal_panel.problem_slot_1.set_memo(IntegerMemo, addend_1, true)
	goal_panel.problem_slot_2.set_memo(IntegerMemo, addend_2, true)

	output_program = pim.get_program("GiveOutputMemo")
	output_program.run()

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	return {"addend_1": addend_1, "addend_2": addend_2}
