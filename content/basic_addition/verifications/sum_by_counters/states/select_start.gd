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

var number_effect: NumberEffect


func _enter(_last_state: String) -> void:
	assert(verification.setup_completed)

	number_effect = verification.slot_panel.create_number_effect("addend_1")

	await Game.wait_for(0.5)

	pack.run_process("select_start", [verification.pim, number_effect], self, "_on_highlight")


func _on_highlight() -> void:
	await Game.wait_for(0.5)

	_change_state("PutCounters")
