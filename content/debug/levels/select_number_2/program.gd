#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends LevelProgram


func _start() -> void:
	super()

	goal_panel.slot.set_memo(IntegerMemo, 27, true)
	goal_panel.slot_filled.connect(complete_level)


func _end() -> void:
	goal_panel.slot_filled.disconnect(complete_level)
