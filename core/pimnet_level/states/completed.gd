#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends State

var level: Level:
	get:
		return _target
var overlay: PimnetOverlay:
	get:
		return level.pimnet.overlay


func _enter(_last_state: String) -> void:
	match overlay.goal_type:
		PimnetOverlay.GoalPanels.HINTED_MEMO_SLOT:
			overlay.goal_panel.slot.set_input_output_ability(false, false)
			overlay.goal_panel.slot.set_faded(false)
			overlay.goal_panel.slot.set_highlight(MemoSlot.HighlightTypes.AFFIRMATION)
		PimnetOverlay.GoalPanels.SOLUTION_MEMO_SLOTS:
			overlay.goal_panel.close_verification_panel()
			overlay.goal_panel.solution_slot.set_input_output_ability(false, false)
			overlay.goal_panel.solution_slot.set_highlight(
					MemoSlot.HighlightTypes.AFFIRMATION)

	if Game.current_level != null:
		Game.progress_data.save_level_completion(Game.current_level.id)
	overlay.show_completion_popup()