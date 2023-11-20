##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends LevelProgramState

var _count_program: SoftLimiterProgram


func _enter(last_state: String) -> void:
	if last_state == "VerifyStart":
		program.pim.menu_control.tool_menu.disable_tool("SquareMarker")
		program.pim.menu_control.tool_menu.add_tool("NumberCircler")
		program.pim.field.set_tool("NumberCircler")

	level.metanavig_control.set_custom_reset(self, "_on_reset")

	event_control.menu.enabler.connect_button(program.BUTTON_ID, self, "_check_condition")
	event_control.menu.connect_event(program.BUTTON_ID, self, "next")

	_count_program = program.pim.field.get_program("SoftAddByCircles")
	_count_program.setup(program.start_number, program.addend)
	_count_program.run()


func _on_reset() -> void:
	program.pim.field.reset_state()
	var square = program.pim.field.queries.get_number_square(program.start_number)
	program.pim.field.push_action("toggle_highlight", [square])


func _check_condition() -> bool:
	return not program.field.queries.get_circled_numbers().is_empty() and _count_program.is_valid()


func _exit(_next_state: String) -> void:
	_count_program.stop()
	event_control.menu.enabler.disconnect_all()
	event_control.menu.disconnect_event(program.BUTTON_ID, self, "next")
