# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends VerificationState


func _enter(_last_state: String) -> void:
	# Show 0 where the first count is expected
	var zero_cell_number: int = 1
	var marked_cell = verification.field.get_marked_cell()
	if marked_cell != null:
		zero_cell_number = marked_cell.number + 1

	# Sum pieces in order
	var pieces = verification.field.dynamic_model.get_pieces()
	(GridCountingProcessSumPieces.new(pieces, zero_cell_number)
			.run(verification.field, _on_count_complete))


func _on_count_complete(count: InfoSignal) -> void:
	EqualityVerification.new(count).run(self, verification.row_numbers, verify, reject)


func _exit(_next_state: String) -> void:
	if verification.field != null:
		verification.field.count_signaler.reset_count()
		verification.field.info_signaler.clear()
