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

@export var count: int
@export var _random_count: bool
@export var _min_count: int
@export var _max_count: int

var pim: Pim
var field: Field
var output_program: PimProgram
var field_program: FieldProgram
var intermediate_goal: int


func _setup_vars() -> void:
	count = Utils.eval_given_or_random_int(count, _random_count, _min_count, _max_count)
	if IntegerMath.get_hundreds_digit(count) == 1:
		intermediate_goal = 100
	else:
		intermediate_goal = IntegerMath.get_tens_digit(count) * 10


func _start() -> void:
	super()

	pim = pimnet.get_pim()
	field = pim.field
	field_program = field.get_program("SoftCount")

	goal_panel.slot.set_memo(IntegerMemo, count, true)

	output_program = pim.get_program("GiveOutputMemo")
	output_program.run()

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	return {"count": count}
