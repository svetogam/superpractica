# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

var addend_1: int
var addend_2: int
var pim: Pim
var field: Field
var output_program: PimProgram
var field_program: FieldProgram


func _setup_vars() -> void:
	addend_1 = level.level_data.program_vars.new_addend_1()
	addend_2 = level.level_data.program_vars.new_addend_2()


func _ready() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	goal_panel.set_problem_memo(ExpressionMemo.new(str(addend_1) + "+" + str(addend_2)))

	output_program = pim.get_program("GiveOutputMemo")
	output_program.run()


func _get_instruction_replacements() -> Dictionary:
	return {"addend_1": addend_1, "addend_2": addend_2}


func _on_playing_state_entered() -> void:
	overlay.pim_tools.exclude_all("GridCounting")
	overlay.pim_tools.include("GridCounting", GridCounting.Tools.CELL_MARKER)
	overlay.pim_tools.include("GridCounting", GridCounting.Tools.PIECE_DRAGGER)
	field.set_tool(GridCounting.Tools.CELL_MARKER)
	overlay.pim_objects.include_all("GridCounting")

	field_program = field.get_program("SoftCount")
	field_program.run()

	field.warning_signaler.warned.connect(_set_output_warning.bind(true))
	field.warning_signaler.unwarned.connect(_set_output_warning.bind(false))
	goal_panel.slot_filled.connect(_on_goal_slot_filled)


func _set_output_warning(warned: bool) -> void:
	pim.slot.memo_output_enabled = not warned


func _on_goal_slot_filled() -> void:
	BasicAdditionProcesses.VerifGridCountingAddition.instantiate().setup(pim).run(
		level.verifier, [0, 1], _on_verified
	)


func _on_verified() -> void:
	complete_task()
	$StateChart.send_event("done")


func _on_playing_state_exited() -> void:
	field.warning_signaler.warned.disconnect(_set_output_warning)
	field.warning_signaler.unwarned.disconnect(_set_output_warning)
	goal_panel.slot_filled.disconnect(_on_goal_slot_filled)
