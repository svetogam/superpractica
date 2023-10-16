##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends LevelProgramState


func _enter(_last_state: String) -> void:
	program.fraction.set_fraction(program.numerator, program.denominator)
	program.fraction.set_slot_input_output_ability(false, false, "numerator")
	program.fraction.set_slot_input_output_ability(false, false, "denominator")

	program.field.actions.split_pie_into_equal_regions(program.denominator,
			PieSlicerGlobals.SliceVariants.GUIDE)

	_transition("done")
