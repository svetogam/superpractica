# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

var number: int
var pim: Pim
var field: Field


func _setup_vars(level_vars: Dictionary) -> void:
	number = level_vars["number"]


func _ready() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	pim.enable_output_slot()
	goal_panel.slot.set_memo_as_hint(IntegerMemo, number)


func _get_instruction_replacements() -> Dictionary:
	return {"number": number}


func _on_select_cell_state_entered() -> void:
	field.set_tool(GridCounting.TOOL_CELL_MARKER)

	%SelectCorrectCellProgram.field = field
	%SelectCorrectCellProgram.start_number = number
	%SelectCorrectCellProgram.run()


func _on_select_correct_cell_program_completed() -> void:
	complete_task()
	$StateChart.send_event("done")


func _on_drag_memo_state_entered() -> void:
	field.set_tool(Field.NO_TOOL)

	goal_panel.slot_filled.connect(_on_goal_slot_filled)


func _on_goal_slot_filled() -> void:
	complete_task()
	$StateChart.send_event("done")
