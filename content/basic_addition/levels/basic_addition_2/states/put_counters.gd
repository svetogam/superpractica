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
		program.pim.menu_control.tool_menu.disable_tool("SquareMarker")
		program.pim.menu_control.tool_menu.add_tool("CounterDragger")
		program.pim.field.set_tool("CounterDragger")
		var spawn_panel = program.pim.menu_control.add_spawn_panel()
		spawn_panel.add_spawner(CountingBoard.Objects.COUNTER)

	level.reversion_control.set_custom_reset(_on_reset)

	event_control.menu.enabler.connect_button(program.BUTTON_ID, _check_condition)
	event_control.menu.connect_event(program.BUTTON_ID, next)

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
	event_control.menu.enabler.disconnect_all()
	event_control.menu.disconnect_event(program.BUTTON_ID, next)
