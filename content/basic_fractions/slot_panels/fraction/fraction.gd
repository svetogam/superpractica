##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends SlotPanel

export(bool) var initial_num_is_empty := false
export(int) var initial_num := 0
export(bool) var initial_denom_is_empty := false
export(int) var initial_denom := 1
onready var _numerator_slot := $"%NumeratorSlot"
onready var _denominator_slot := $"%DenominatorSlot"


func _ready() -> void:
	_setup_slot_map()


func _setup_slot_map() -> void:
	_setup_slot(_numerator_slot, "numerator")
	_setup_slot(_denominator_slot, "denominator")

	set_fraction(initial_num, initial_denom)

	if initial_num_is_empty:
		set_slot_empty("numerator")
	if initial_denom_is_empty:
		set_slot_empty("denominator")


func set_fraction(numerator: int, denominator: int) -> void:
	set_slot(IntegerMemo, numerator, "numerator")
	set_slot(IntegerMemo, denominator, "denominator")
