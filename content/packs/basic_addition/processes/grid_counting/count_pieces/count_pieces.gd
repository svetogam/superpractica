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
	GridCountingProcessCountPieces.new(pieces, 1).run(field, _on_count_complete)


func _on_count_complete(count: NumberSignal) -> void:
	EqualityVerification.new(count).run(self, row_numbers, verify, reject)
