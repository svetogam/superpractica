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


func _enter(last_state: String) -> void:
	if last_state == State.NULL_STATE:
		tool_panel.exclude_all("GridCounting")
		tool_panel.include("GridCounting", GridCounting.Tools.CELL_MARKER)
		tool_panel.include("GridCounting", GridCounting.Tools.PIECE_DRAGGER)
		program.field.set_tool(GridCounting.Tools.CELL_MARKER)
		creation_panel.exclude_all("GridCounting")
		creation_panel.include("GridCounting", GridCounting.Objects.UNIT)

		_field_program = program.field.get_program("SoftCount")
		_field_program.run()

	program.field.warning_effects.warned.connect(_set_output_warning.bind(true))
	program.field.warning_effects.unwarned.connect(_set_output_warning.bind(false))
	goal_panel.slot_filled.connect(_on_goal_slot_filled)


func _set_output_warning(warned: bool) -> void:
	program.pim.output_slot.memo_output_enabled = not warned
	if warned:
		program.pim.output_slot.set_highlight(MemoSlot.HighlightTypes.WARNING)
	else:
		program.pim.output_slot.set_highlight(MemoSlot.HighlightTypes.REGULAR)


func _on_goal_slot_filled() -> void:
	(BasicAdditionProcesses.VerifGridCountingAddition.instantiate()
			.setup(program.pim)
			.run(verifier, complete))


func _exit(_next_state: String) -> void:
	program.field.warning_effects.warned.disconnect(_set_output_warning)
	program.field.warning_effects.unwarned.disconnect(_set_output_warning)
	goal_panel.slot_filled.disconnect(_on_goal_slot_filled)
