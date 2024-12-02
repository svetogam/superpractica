#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends LevelProgram

var object_sum_icon := preload(
		"res://content/packs/basic_addition/pims/grid_counting/field/graphics/"
		+ "condition_sum_icon.svg")
var object_count_icon := preload(
		"res://content/packs/basic_addition/pims/grid_counting/field/graphics/"
		+ "condition_objects_icon.svg")
var object_sum: int
var object_count: int
var pim: Pim
var field: Field


func _setup_vars() -> void:
	object_sum = Game.current_level.program_vars.object_sum
	object_count = Game.current_level.program_vars.object_count


func _start() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field

	goal_panel.add_condition(IntegerMemo.new(object_sum), object_sum_icon)
	goal_panel.add_condition(IntegerMemo.new(object_count), object_count_icon)

	$StateMachine.activate()
