# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram

var count: int
var pim: Pim
var field: Field
var output_program: PimProgram
var field_program: FieldProgram


func _setup_vars() -> void:
	count = level.level_data.program_vars.new_count()


func _start() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	goal_panel.slot.set_memo_as_hint(IntegerMemo, count)

	output_program = pim.get_program("GiveOutputMemo")
	output_program.run()


func _get_instruction_replacements() -> Dictionary:
	return {"count": count}


func _on_put_units_state_entered() -> void:
	overlay.pim_objects.exclude_all("GridCounting")
	overlay.pim_objects.include("GridCounting", GridCounting.Objects.UNIT)

	field_program = pim.field.get_program("CountByUnits")
	field_program.setup(0, count)
	field_program.run()
	field_program.completed.connect(_on_field_program_completed)


func _on_field_program_completed() -> void:
	complete_task()
	$StateChart.send_event("done")


func _on_put_units_state_exited() -> void:
	field_program.completed.disconnect(_on_field_program_completed)


func _on_drag_memo_state_entered() -> void:
	field.set_tool(Game.NO_TOOL)
	pimnet.overlay.deactivate_panel(PimnetOverlay.PimnetPanels.PIM_OBJECTS)

	goal_panel.slot_filled.connect(_on_goal_slot_filled)


func _on_goal_slot_filled() -> void:
	complete_task()
	$StateChart.send_event("done")
