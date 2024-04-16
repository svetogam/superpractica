#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends LevelProgramState

var _field_program: FieldProgram


func _enter(_last_state: String) -> void:
	tool_panel.disable("CountingBoard", CountingBoard.Tools.SQUARE_MARKER)
	tool_panel.include("CountingBoard", CountingBoard.Tools.NUMBER_CIRCLER)
	program.pim.field.set_tool(CountingBoard.Tools.NUMBER_CIRCLER)

	_field_program = program.pim.field.get_program("AddByCircles")
	_field_program.setup(program.start_number, program.addend)
	_field_program.run()
	_field_program.completed_tens_only.connect(complete)
	_field_program.completed.connect(_on_complete_complete)

	if program.addend < 10:
		complete()


func _on_complete_complete() -> void:
	complete_task()
	complete_task()
	complete()


func _exit(_next_state: String) -> void:
	_field_program.completed_tens_only.disconnect(complete)
	_field_program.completed.disconnect(_on_complete_complete)
