# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

var level: Level:
	get:
		return _target
var overlay: PimnetOverlay:
	get:
		return level.pimnet.overlay


func _enter(_last_state: String) -> void:
	match level.level_data.goal_type:
		LevelResource.GoalTypes.HINTED_MEMO_SLOT:
			overlay.goal_panel.slot.memo_input_enabled = false
			overlay.goal_panel.slot.suggestion = Game.SuggestiveSignals.AFFIRM
		LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS:
			overlay.goal_panel.solution_slot.memo_input_enabled = false
			overlay.goal_panel.solution_slot.suggestion = Game.SuggestiveSignals.AFFIRM
			overlay.goal_panel.check_slot.suggestion = Game.SuggestiveSignals.AFFIRM
		LevelResource.GoalTypes.CONSTRUCT_CONDITIONS:
			overlay.goal_panel.verify_button.disabled = true

	Game.progress_data.record_level_completion(level.level_data.id)
	%OverlayStateMachine.change_state("Completion")
