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


func _enter(_last_state: String) -> void:
	assert(verification.setup_completed)

	verification.digit_reference = verification.slot_panel.create_number_effect("addend_2")

	await Game.wait_for(0.8)

	screen_verifier.set_digit_reference(verification.digit_reference, self, "_on_move_completed")


func _on_move_completed() -> void:
	verification.addend_tens_digit = verification.digit_reference.number / 10
	if verification.addend_tens_digit == 0:
		_change_state("CheckOnes")
	else:
		_change_state("CheckTens")
