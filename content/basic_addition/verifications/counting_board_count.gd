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

var field: Field
var slot_panel: SlotPanel


func setup(p_field: Field, p_slot_panel: SlotPanel) -> void:
	field = p_field
	slot_panel = p_slot_panel


func _ready() -> void:
	var counters = field.queries.get_counter_list()
	field.run_process("count_counters", [counters], self, "_on_count_complete")


func _on_count_complete(count: NumberEffect) -> void:
	var slot_number = slot_panel.create_number_effect("addend_2")

	await Game.wait_for(screen_verifier.START_DELAY)

	screen_verifier.verify("numbers_are_equal", [count, slot_number],
			self, "verify", "reject")


func _exit_tree() -> void:
	field.clear_effects()
	slot_panel.clear_effects()
