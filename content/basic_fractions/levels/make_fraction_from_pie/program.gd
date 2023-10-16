##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends LevelProgram

export(int) var total_regions := 2
export(int) var selected_regions := 1
export(bool) var _random := false
export(int) var _min_total_regions := 2
export(int) var _max_total_regions := 9
export(bool) var _force_one_selected := false
export(bool) var _force_one_unselected := false

const BUTTON_ID := "button"
const BUTTON_TEXT := "Check"
var button: Button
var pim: Pim
var field: Field
var fraction: SlotPanel


func _setup_vars() -> void:
	total_regions = Utils.eval_given_or_random_int(total_regions, _random,
			_min_total_regions, _max_total_regions)

	var max_selected = total_regions
	var min_selected = 0
	if _force_one_selected:
		min_selected += 1
	if _force_one_unselected:
		max_selected -= 1
	selected_regions = Utils.eval_given_or_random_int(selected_regions, _random,
			min_selected, max_selected)


func _start() -> void:
	button = event_control.menu.add_button(BUTTON_ID, BUTTON_TEXT)
	pim = pimnet.get_pim("PieSlicerPim")
	field = pim.field
	fraction = pimnet.get_window_content("FractionWindow", "Fraction")

	$StateMachine.activate()
