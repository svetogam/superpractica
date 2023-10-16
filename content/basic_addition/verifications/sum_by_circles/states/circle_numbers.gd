##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends VerificationState

var _digit_reference: NumberEffect


func _enter(_last_state: String) -> void:
	_digit_reference = verification.slot_panel.create_number_effect("addend_2")

	yield(Game.wait_for(0.8), Game.DONE)

	screen_verifier.set_digit_reference(_digit_reference, self, "_on_move_completed")


func _on_move_completed() -> void:
	var start_square = verification.pim.field.queries.get_highlighted_number_square()
	verification.pim.field.run_process("add_by_circles",
			[start_square.number, _digit_reference.number, true],
			self, "_on_circling_completed")


func _on_circling_completed() -> void:
	_change_state("CompareResult")


func _exit(_next_state: String) -> void:
	screen_verifier.clear_digit_reference()
