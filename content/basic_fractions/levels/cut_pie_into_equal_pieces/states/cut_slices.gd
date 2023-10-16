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
	program.pim.field.get_program("SliceByGuides").run()

	event_control.menu.connect_event(program.BUTTON_ID, self, "_on_check_button_pressed")


func _on_check_button_pressed() -> void:
	var pie = program.field.pie
	var prefig = pie.slice_prefig
	pie.remove_child(prefig)

	if program.field.queries.do_slices_match_guides():
		pie.add_child(prefig)
		_transition("done")
	else:
		pie.add_child(prefig)


func _exit(_next_state: String) -> void:
	event_control.menu.disconnect_event(program.BUTTON_ID, self, "_on_check_button_pressed")
	program.pim.field.get_program("SliceByGuides").stop()
