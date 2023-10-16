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
	program.pim.window.disable()

	event_control.menu.enabler.disable_all(false)
	event_control.menu.connect_event(program.BUTTON_ID, self, "complete")
	event_control.menu.point_at_button(program.BUTTON_ID)


func _exit(_next_state: String) -> void:
	event_control.menu.clear_effects()
	event_control.menu.disconnect_event(program.BUTTON_ID, self, "complete")
