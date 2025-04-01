# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends VerificationState


func _enter(_last_state: String) -> void:
	# Make number signal at marked cell
	var board_number: NumberSignal
	var marked_cell = verification.field.get_marked_cell()
	if marked_cell != null:
		board_number = verification.field.popup_number_by_grid_cell(marked_cell)
	# Or make a 0 number signal at first cell if no cell is marked
	else:
		var first_cell = verification.field.dynamic_model.get_grid_cell(1)
		board_number = verification.field.info_signaler.popup_number(
				0, first_cell.position)

	await Game.wait_for(0.5)

	(EqualityVerification.new(board_number)
			.run(self, verification.row_numbers, _on_verify, reject))


func _on_verify() -> void:
	_change_state("CheckPieces")


func _exit(_next_state: String) -> void:
	if verification.field != null:
		verification.field.info_signaler.clear()
