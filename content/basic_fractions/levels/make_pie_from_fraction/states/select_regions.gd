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


func _enter(_last_state: String) -> void:
	program.pim.menu_control.tool_menu.disable_tools(["SliceAdder", "SliceRemover"])
	program.pim.menu_control.tool_menu.enable_tool("RegionSelector")
	program.pim.field.set_tool("RegionSelector")

	event_control.menu.enabler.connect_button(program.BUTTON_ID, self, "_check_condition")
	event_control.menu.connect_event(program.BUTTON_ID, self, "next")


func _check_condition() -> bool:
	return program.field.queries.get_number_of_selected_regions() > 0


func _exit(_next_state: String) -> void:
	event_control.menu.enabler.disconnect_button(program.BUTTON_ID, self, "_check_condition")
	event_control.menu.disconnect_event(program.BUTTON_ID, self, "next")
