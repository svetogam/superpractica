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
	event_control.menu.enabler.connect_button(program.BUTTON_ID, _check_condition)
	event_control.menu.connect_event(program.BUTTON_ID, next)


func _check_condition() -> bool:
	return program.field.is_any_square_highlighted()


func _exit(_next_state: String) -> void:
	event_control.menu.enabler.disconnect_all()
	event_control.menu.disconnect_event(program.BUTTON_ID, next)
