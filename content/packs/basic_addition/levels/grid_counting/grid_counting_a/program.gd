# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

var count: int
var pim: Pim
var field: Field
var output_program: PimProgram


func _setup_vars() -> void:
	count = Game.current_level.program_vars.new_count()


func _start() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	goal_panel.slot.set_memo_as_hint(IntegerMemo, count)

	output_program = pim.get_program("GiveOutputMemo")
	output_program.run()

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	return {"count": count}
