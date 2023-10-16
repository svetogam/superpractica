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

const DELAY := 0.2


func _enter(_last_state: String) -> void:
	yield(Game.wait_for(DELAY), Game.DONE)

	verification.field.run_process("count_circles_in_direction",
			[verification.start_number, "down"], self, "_on_count_complete")


func _on_count_complete(count: NumberEffect) -> void:
	yield(Game.wait_for(DELAY), Game.DONE)

	screen_verifier.verify("number_is_equal_to_digit", [count, 2],
			self, "_on_verify", "_on_reject")


func _on_verify() -> void:
	_change_state("CheckOnes")


func _on_reject() -> void:
	screen_verifier.clear_digit_reference()
	reject()


func _exit(_next_state: String) -> void:
	verification.field.counter.reset_count()
