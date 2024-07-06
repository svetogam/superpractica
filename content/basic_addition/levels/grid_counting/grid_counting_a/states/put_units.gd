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

	_field_program = program.field.get_program("SoftCount")
	_field_program.setup(0) # Count should proceed starting at 1
	_field_program.run()

	program.output_program.output_decided.connect(_on_output_decided)
	program.field.warning_effects.warned.connect(_set_output_warning.bind(true))
	program.field.warning_effects.unwarned.connect(_set_output_warning.bind(false))


func _on_output_decided(output_number: int) -> void:
	if output_number == program.count and _field_program.is_valid():
		_set_output_warning(false)
		complete()


func _set_output_warning(warned: bool) -> void:
	program.pim.output_slot.memo_output_enabled = not warned
	if warned:
		program.pim.output_slot.set_highlight(MemoSlot.HighlightTypes.WARNING)
	else:
		program.pim.output_slot.set_highlight(MemoSlot.HighlightTypes.REGULAR)


func _exit(_next_state: String) -> void:
	program.output_program.output_decided.disconnect(_on_output_decided)
	program.field.warning_effects.warned.disconnect(_set_output_warning)
	program.field.warning_effects.unwarned.disconnect(_set_output_warning)
