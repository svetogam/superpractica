# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgramState

var _field_program: FieldProgram


func _enter(_last_state: String) -> void:
	program.field.set_tool(GridCounting.Tools.PIECE_DRAGGER)
	overlay.pim_objects.exclude_all("GridCounting")
	overlay.pim_objects.include("GridCounting", GridCounting.Objects.UNIT)

	_field_program = program.field.get_program("SoftCount")
	_field_program.run()

	program.output_program.output_decided.connect(_on_output_decided)
	program.field.warning_signaler.warned.connect(_set_output_warning.bind(true))
	program.field.warning_signaler.unwarned.connect(_set_output_warning.bind(false))


func _on_output_decided(output_number: int) -> void:
	if output_number == program.count and _field_program.is_valid():
		_set_output_warning(false)
		complete()


func _set_output_warning(warned: bool) -> void:
	program.pim.slot.memo_output_enabled = not warned


func _exit(_next_state: String) -> void:
	program.output_program.output_decided.disconnect(_on_output_decided)
	program.field.warning_signaler.warned.disconnect(_set_output_warning)
	program.field.warning_signaler.unwarned.disconnect(_set_output_warning)
