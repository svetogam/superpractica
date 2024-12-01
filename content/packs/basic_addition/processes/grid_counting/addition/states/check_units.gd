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


func _enter(_last_state: String) -> void:
	# Show 0 where the first count is expected
	var zero_cell_number: int = 1
	var marked_cell = verification.field.get_marked_cell()
	if marked_cell != null:
		zero_cell_number = marked_cell.number + 1
	var zero_position = verification.field.dynamic_model.get_grid_cell(
			zero_cell_number).position

	# Count units in order
	var units = verification.field.dynamic_model.get_units()
	(GridCountingProcessCountPieces.new(units, zero_position)
			.run(verification.field, _on_count_complete))


func _on_count_complete(count: NumberEffect) -> void:
	goal_verifier.verify_equality(
			count, verification_panel.empty_row_numbers, verify, reject)


func _exit(_next_state: String) -> void:
	if verification.field != null:
		verification.field.effect_counter.reset_count()
