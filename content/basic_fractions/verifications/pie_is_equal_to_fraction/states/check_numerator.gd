##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends VerificationState


func _enter(_last_state: String) -> void:
	assert(verification.setup_completed)

	var selected_regions = verification.pim.field.queries.get_selected_region_list().size()

	if selected_regions > 0:
		var to_count = verification.pim.field.queries.get_selected_region_list()
		verification.pim.field.run_process("count_regions", [to_count], self, "_on_regions_counted")
	else:
		reject()


func _on_regions_counted(count: NumberEffect) -> void:
	var numerator = verification.fraction.create_number_effect("numerator")

	yield(Game.wait_for(screen_verifier.START_DELAY), Game.DONE)

	screen_verifier.verify("numbers_are_equal", [count, numerator],
			self, "_on_verified", "_on_rejected")


func _on_verified() -> void:
	_change_state("CheckDenominator")


func _on_rejected() -> void:
	verification.pim.field.actions.clear_count()
	verification.fraction.clear_effects()
	reject()
