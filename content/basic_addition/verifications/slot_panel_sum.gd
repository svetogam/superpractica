##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Verification

var slot_panel: SlotPanel


func setup(p_slot_panel: SlotPanel) -> void:
	slot_panel = p_slot_panel


func _ready() -> void:
	var plus = slot_panel.create_plus_effect()
	var number_1 = slot_panel.create_number_effect("addend_1")
	var number_2 = slot_panel.create_number_effect("addend_2")
	var sum_number = slot_panel.create_number_effect("sum")

	yield(Game.wait_for(screen_verifier.START_DELAY), Game.DONE)

	screen_verifier.verify("evaluates_to_number", [sum_number, plus, [number_1, number_2]],
			self, "verify", "reject")


func _exit_tree() -> void:
	slot_panel.clear_effects()
