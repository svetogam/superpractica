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

@export var start_number: int
@export var addend: int
@export var _random_start_number: bool
@export var _min_start_number: int
@export var _max_start_number: int
@export var _random_addend: bool
@export var _min_addend: int
@export var _max_addend: int

var pim: Pim
var field: Field
var slot_panel: SlotPanel
var sum_slot: MemoSlot


func _setup_vars() -> void:
	start_number = Utils.eval_given_or_random_int(start_number,
			_random_start_number, _min_start_number, _max_start_number)
	addend = Utils.eval_given_or_random_int(
			addend, _random_addend, _min_addend, _max_addend)


func _start() -> void:
	super()

	tool_panel.exclude_all()
	goal_panel.activate_check_button()
	pim = pimnet.get_pim("CountingBoardPim")
	field = pim.field
	slot_panel = pimnet.get_window_content("SlotPanelWindow", "SumSlots")
	sum_slot = slot_panel.get_slot("sum")

	slot_panel.set_slot(IntegerMemo, start_number, "addend_1")
	slot_panel.set_slot(IntegerMemo, addend, "addend_2")
	slot_panel.set_slot_input_output_ability(false, false, "addend_1")
	slot_panel.set_slot_input_output_ability(false, false, "addend_2")
	slot_panel.set_slot_input_output_ability(true, false, "sum")

	$StateMachine.activate()


func _get_instruction_replacements() -> Dictionary:
	var addend_tens_digit: int = addend / 10
	var addend_ones_digit: int = addend % 10
	var partial_completion: int = start_number + addend_tens_digit * 10
	return {"start_number": start_number, "addend": addend,
			"addend_tens": addend_tens_digit, "addend_ones": addend_ones_digit,
			"partial_completion": partial_completion}
