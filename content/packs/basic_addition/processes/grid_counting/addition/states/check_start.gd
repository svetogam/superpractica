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

const START_DELAY := 0.8


func _enter(_last_state: String) -> void:
	await Game.wait_for(START_DELAY)

	# Make number-effect at highlighted cell
	var board_number: NumberEffect
	var marked_cell = verification.field.get_highlighted_grid_cell()
	if marked_cell != null:
		board_number = verification.field.give_number_effect_by_grid_cell(marked_cell)
	# Or make a 0 number-effect at first cell if no cell is highlighted
	else:
		var first_cell = verification.field.get_grid_cell(1)
		board_number = verification.field.math_effects.give_number(0, first_cell.position)

	await Game.wait_for(0.5)

	goal_verifier.verify_equality(
			board_number, verification_panel.row_numbers, _on_verify, reject)


func _on_verify() -> void:
	_change_state("CheckUnits")
