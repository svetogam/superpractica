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

var _count_program: SoftLimiterProgram


func _enter(last_state: String) -> void:
	if last_state == "VerifyStart":
		tool_panel.disable(CountingBoard.Tools.SQUARE_MARKER)
		tool_panel.include(CountingBoard.Tools.COUNTER_DRAGGER)
		program.pim.field.set_tool(CountingBoard.Tools.COUNTER_DRAGGER)
		creation_panel.include(CountingBoard.Objects.COUNTER)

	level.reversion_control.set_custom_reset(_on_reset)

	goal_panel.add_check_condition(_check_condition)
	goal_panel.connect_goal_check(next)

	_count_program = program.pim.field.get_program("SoftCountByCounters")
	_count_program.setup(program.start_number)
	_count_program.run()


func _on_reset() -> void:
	var field = program.pim.field
	field.reset_state()
	var square = field.get_number_square(program.start_number)
	field.push_action(field.toggle_highlight.bind(square))


func _check_condition() -> bool:
	return not program.field.get_counter_list().is_empty() and _count_program.is_valid()


func _exit(_next_state: String) -> void:
	_count_program.stop()
	goal_panel.remove_check_condition(_check_condition)
	goal_panel.disconnect_goal_check()
