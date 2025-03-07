# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgramState

var _field_program: FieldProgram


func _enter(_last_state: String) -> void:
	program.field.set_tool(GridCounting.Tools.CELL_MARKER)

	_field_program = program.field.get_program("SelectCorrectCell")
	_field_program.setup(program.number)
	_field_program.run()
	_field_program.completed.connect(complete)


func _exit(_next_state: String) -> void:
	_field_program.completed.disconnect(complete)
