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
	GridCountingProcessSumPieces.new().run(field, _on_sum_complete)


func _on_sum_complete(sum: NumberEffect) -> void:
	goal_verifier.verify_equality(sum, [0], verify, reject)


func _exit_tree() -> void:
	if field != null:
		field.math_effects.clear()
