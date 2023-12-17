#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Verification

var field: Field
var slot_panel: SlotPanel
var start_number: int
var digit_reference: NumberEffect
var addend_tens_digit: int


func setup(p_field: Field, p_slot_panel: SlotPanel, p_start_number: int) -> Verification:
	field = p_field
	slot_panel = p_slot_panel
	start_number = p_start_number
	return self
