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
	var unselected_regions = verification.pim.field.queries.get_unselected_region_list().size()

	if unselected_regions > 0:
		var to_count = verification.pim.field.queries.get_unselected_region_list()
		verification.pim.field.run_process("count_regions", [to_count], self, "_on_regions_counted")
	else:
		var count = verification.pim.field.counter.get_highest_count_object()
		_on_regions_counted(count)


func _on_regions_counted(count: NumberEffect) -> void:
	var denominator = verification.fraction.create_number_effect("denominator")

	yield(Game.wait_for(screen_verifier.START_DELAY), Game.DONE)

	screen_verifier.verify("numbers_are_equal", [count, denominator],
			self, "verify", "reject")


func _exit(_next_state: String) -> void:
	verification.pim.field.actions.clear_count()
	verification.fraction.clear_effects()
