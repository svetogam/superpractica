# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Verification

const START_DELAY := 0.8
var pim: Pim
var field: GridCounting


func setup(p_pim: Pim) -> Verification:
	pim = p_pim
	field = pim.field
	return self


func _ready() -> void:
	await Game.wait_for(START_DELAY)
	var pieces = field.dynamic_model.get_pieces()
	GridCountingProcessSumPieces.new(pieces, 1).run(field, _on_sum_complete)


func _on_sum_complete(sum: InfoSignal) -> void:
	EqualityVerification.new(sum).run(self, row_numbers, verify, reject)



func _exit_tree() -> void:
	if field != null:
		field.info_signaler.clear()
