#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends VerificationState


func _enter(_last_state: String) -> void:
	await Game.wait_for(0.5)

	(BasicAdditionGlobals.VerifCountingBoardSum
			.new(verification.pim.field, verification.slot_panel)
			.run(verifier, verify, reject))
