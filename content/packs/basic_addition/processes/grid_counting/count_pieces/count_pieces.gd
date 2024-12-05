#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Verification

const START_DELAY := 0.8
var pim: FieldPim
var field: GridCounting


func setup(p_pim: FieldPim) -> Verification:
	pim = p_pim
	field = pim.field
	return self


func _ready() -> void:
	await Game.wait_for(START_DELAY)

	var pieces = field.dynamic_model.get_pieces()
	var zero_position = field.dynamic_model.get_grid_cell(1).position
	(GridCountingProcessCountPieces.new(pieces, zero_position)
			.run(field, _on_count_complete))


func _on_count_complete(count: NumberEffect) -> void:
	goal_verifier.verify_equality(count, row_numbers, verify, reject)


func _exit_tree() -> void:
	if field != null:
		field.effect_counter.reset_count()
