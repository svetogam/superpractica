# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

var addend_1: int
var addend_2: int
var pim: Pim
var field: Field
var output_program: PimProgram


func _setup_vars() -> void:
	addend_1 = level.level_data.program_vars.new_addend_1()
	addend_2 = level.level_data.program_vars.new_addend_2()


func _start() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	goal_panel.set_problem_memo(ExpressionMemo.new(str(addend_1) + "+" + str(addend_2)))

	output_program = pim.get_program("GiveOutputMemo")
	output_program.run()

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	return {"addend_1": addend_1, "addend_2": addend_2}
