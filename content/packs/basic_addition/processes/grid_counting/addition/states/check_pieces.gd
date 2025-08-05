# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends VerificationState


func _enter(_last_state: String) -> void:
	%SumPiecesProgram.field = verification.field
	%SumPiecesProgram.items = verification.field.dynamic_model.get_pieces()
	var marked_cell = verification.field.get_marked_cell()
	if marked_cell != null:
		%SumPiecesProgram.zero_cell_number = marked_cell.number + 1
	%SumPiecesProgram.run()


func _on_sum_pieces_program_completed(last_count_object: NumberSignal) -> void:
	EqualityVerification.new(last_count_object).run(
		self, verification.row_numbers, verify, reject
	)


func _exit(_next_state: String) -> void:
	if verification.field != null:
		verification.field.count_signaler.reset_count()
		verification.field.info_signaler.clear()
