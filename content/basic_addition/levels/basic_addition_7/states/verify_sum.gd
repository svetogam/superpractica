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
	level.verifier.get_pack("BasicAdditionPack").verify("sum_by_circles",
			[program.pim, program.slot_panel], self, "verify", "_on_rejected")


func _on_rejected() -> void:
	program.field.actions.set_empty()
	_transition("rejected")
