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
	program.field.set_tool(GridCounting.Tools.PIECE_DRAGGER)
	creation_panel.exclude_all("GridCounting")
	creation_panel.include("GridCounting", GridCounting.Objects.UNIT)
	creation_panel.include("GridCounting", GridCounting.Objects.TWO_BLOCK)
	creation_panel.include("GridCounting", GridCounting.Objects.TEN_BLOCK)

	_field_program = program.field.get_program("SoftCount")
	_field_program.run()

	goal_panel.verification_requested.connect(_on_verification_requested)


func _on_verification_requested() -> void:
	(BasicAdditionProcesses.VerifGridCountingAddition.instantiate()
			.setup(program.pim)
			.run(verifier, complete_task))


func _exit(_next_state: String) -> void:
	goal_panel.verification_requested.disconnect(_on_verification_requested)
