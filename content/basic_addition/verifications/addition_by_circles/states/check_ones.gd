#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends VerificationState

const DELAY := 0.2


func _enter(_last_state: String) -> void:
	await Game.wait_for(DELAY)

	var second_start_number = (verification.start_number
			+ verification.addend_tens_digit * 10)
	(CountingBoard.ProcessCountCirclesInDirection.new(second_start_number, "right")
			.run(verification.field, _on_count_complete))


func _on_count_complete(count: NumberEffect) -> void:
	await Game.wait_for(DELAY)

	(ScreenVerifier.VerifNumberIsEqualToDigit.new(count, 1)
			.run(screen_verifier, verify, reject))


func _exit(_next_state: String) -> void:
	screen_verifier.clear_digit_reference()
	verification.field.effect_counter.reset_count()
