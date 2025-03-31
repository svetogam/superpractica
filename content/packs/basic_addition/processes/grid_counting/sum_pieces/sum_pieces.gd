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

	var pieces = field.dynamic_model.get_pieces()
	GridCountingProcessSumPieces.new(pieces, 1).run(field, _on_sum_complete)


func _on_sum_complete(sum: InfoSignal) -> void:
	EqualityVerification.new(sum).run(self, row_numbers, verify, reject)
