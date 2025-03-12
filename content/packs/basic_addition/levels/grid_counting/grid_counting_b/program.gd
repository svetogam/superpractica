# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

var count: int
var pim: Pim
var field: Field
var output_program: PimProgram
var field_program: FieldProgram
var intermediate_goal: int


func _setup_vars() -> void:
	count = Game.current_level.program_vars.new_count()
	if IntegerMath.get_hundreds_digit(count) == 1:
		intermediate_goal = 100
	else:
		intermediate_goal = IntegerMath.get_tens_digit(count) * 10


func _start() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field
	field_program = field.get_program("SoftCount")

	goal_panel.slot.set_memo_as_hint(IntegerMemo, count)

	output_program = pim.get_program("GiveOutputMemo")
	output_program.run()

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	return {"count": count}
