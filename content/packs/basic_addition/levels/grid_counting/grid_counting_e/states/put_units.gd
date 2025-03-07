# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgramState

var _field_program: FieldProgram


func _enter(_last_state: String) -> void:
	overlay.pim_objects.exclude_all("GridCounting")
	overlay.pim_objects.include("GridCounting", GridCounting.Objects.UNIT)

	_field_program = program.pim.field.get_program("CountByUnits")
	_field_program.setup(0, program.count)
	_field_program.run()
	_field_program.completed.connect(complete)


func _exit(_next_state: String) -> void:
	_field_program.completed.disconnect(complete)
