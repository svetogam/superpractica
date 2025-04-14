# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgramState


func _enter(_last_state: String) -> void:
	program.field.set_tool(Game.NO_TOOL)
	pimnet.overlay.deactivate_panel(PimnetOverlay.PimnetPanels.PIM_OBJECTS)

	goal_panel.slot_filled.connect(complete)
