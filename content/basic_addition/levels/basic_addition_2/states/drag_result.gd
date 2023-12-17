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


func _enter(last_state: String) -> void:
	if last_state == "VerifyCount":
		program.pim.menu_control.tool_menu.disable_tool("CounterDragger")
		program.pim.menu_control.tool_menu.add_tool("MemoGrabber")
		program.pim.field.set_tool("MemoGrabber")
		program.pim.menu_control.remove_panel(PimSideMenu.PimMenuPanels.OBJECT_GENERATOR)

		level.reversion_control.set_no_reset()

	event_control.menu.enabler.connect_button(program.BUTTON_ID, _check_condition)
	event_control.menu.connect_event(program.BUTTON_ID, next)


func _check_condition() -> bool:
	return not program.slot_panel.is_slot_empty("sum")


func _exit(_next_state: String) -> void:
	event_control.menu.enabler.disconnect_all()
	event_control.menu.disconnect_event(program.BUTTON_ID, next)
