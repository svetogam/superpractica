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
	match Game.current_level.goal_type:
		LevelResource.GoalTypes.HINTED_MEMO_SLOT:
			overlay.goal_panel.slot.set_input_output_ability(false, false)
			overlay.goal_panel.slot.set_faded(false)
			overlay.goal_panel.slot.set_highlight(MemoSlot.HighlightTypes.AFFIRMATION)
		LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS:
			overlay.verification_panel.close()
			overlay.goal_panel.solution_slot.set_input_output_ability(false, false)
			overlay.goal_panel.solution_slot.set_highlight(
					MemoSlot.HighlightTypes.AFFIRMATION)
		LevelResource.GoalTypes.CONSTRUCT_CONDITIONS:
			overlay.verification_panel.close()
			overlay.goal_panel.verify_button.disabled = true

	Game.set_current_level_completed()
	overlay.show_completion_popup()
