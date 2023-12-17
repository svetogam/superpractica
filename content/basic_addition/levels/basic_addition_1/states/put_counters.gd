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
	program.pim.menu_control.tool_menu.disable_tool("SquareMarker")
	program.pim.field.set_no_tool()
	var spawn_panel = program.pim.menu_control.add_spawn_panel()
	spawn_panel.add_spawner(CountingBoard.Objects.COUNTER)

	_field_program = program.pim.field.get_program("CountByCounters")
	_field_program.setup(program.start_number, program.count)
	_field_program.run()
	_field_program.completed.connect(complete)


func _exit(_next_state: String) -> void:
	_field_program.completed.disconnect(complete)
