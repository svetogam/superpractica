#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends LevelProgramState


func _enter(_last_state: String) -> void:
	program.field.set_tool(Game.NO_TOOL)
	pimnet.overlay.disable_panel(PimnetOverlay.PimnetPanels.PIM_OBJECTS)

	goal_panel.slot_filled.connect(complete)
