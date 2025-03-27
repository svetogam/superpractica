# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgramState

var _field_program: FieldProgram


func _enter(_last_state: String) -> void:
	overlay.pim_tools.exclude_all("GridCounting")
	overlay.pim_tools.include("GridCounting", GridCounting.Tools.CELL_MARKER)
	overlay.pim_tools.include("GridCounting", GridCounting.Tools.PIECE_DRAGGER)
	program.field.set_tool(GridCounting.Tools.CELL_MARKER)
	overlay.pim_objects.exclude_all("GridCounting")
	overlay.pim_objects.include("GridCounting", GridCounting.Objects.UNIT)

	_field_program = program.field.get_program("SoftCount")
	_field_program.run()

	program.field.warning_signaler.warned.connect(_set_output_warning.bind(true))
	program.field.warning_signaler.unwarned.connect(_set_output_warning.bind(false))
	goal_panel.slot_filled.connect(_on_goal_slot_filled)


func _set_output_warning(warned: bool) -> void:
	program.pim.slot.memo_output_enabled = not warned


func _on_goal_slot_filled() -> void:
	(BasicAdditionProcesses.VerifGridCountingAddition.instantiate()
			.setup(program.pim)
			.run(verifier, [0, 1], complete))


func _exit(_next_state: String) -> void:
	program.field.warning_signaler.warned.disconnect(_set_output_warning)
	program.field.warning_signaler.unwarned.disconnect(_set_output_warning)
	goal_panel.slot_filled.disconnect(_on_goal_slot_filled)
