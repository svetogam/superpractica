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


func _enter(_last_state: String) -> void:
	tool_panel.include(CountingBoard.Tools.MEMO_GRABBER)
	program.pim.field.set_tool(CountingBoard.Tools.MEMO_GRABBER)
	tool_panel.force_selection()

	goal_panel.add_check_condition(_check_condition)
	goal_panel.connect_goal_check(next)


func _check_condition() -> bool:
	return not program.slot_panel.is_slot_empty("sum")


func _exit(_next_state: String) -> void:
	goal_panel.remove_check_condition(_check_condition)
	goal_panel.disconnect_goal_check()
