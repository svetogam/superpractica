# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Verification

var pim: Pim
var field: GridCounting


func setup(p_pim: Pim) -> Verification:
	pim = p_pim
	field = pim.field
	return self


func _start() -> void:
	field.count_signaler.reset_count()

	$SumPiecesProgram.field = field
	$SumPiecesProgram.items = field.dynamic_model.get_pieces()
	$SumPiecesProgram.run()


func _on_sum_pieces_program_completed(last_count_object: NumberSignal) -> void:
	EqualityVerification.new(last_count_object).run(self, row_numbers, verify, reject)
