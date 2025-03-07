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


func _enter(last_state: String) -> void:
	if last_state == "Verifying":
		match Game.current_level.goal_type:
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS:
				overlay.verification_panel.close()
				overlay.goal_panel.solution_slot.set_highlight(
						MemoSlot.HighlightTypes.WARNING)
			LevelResource.GoalTypes.CONSTRUCT_CONDITIONS:
				overlay.verification_panel.close()

	if level.program != null:
		level.program.level_completed.connect(_change_state.bind("Completed"))
	level.verifier.verifications_started.connect(_change_state.bind("Verifying"))


func _exit(_next_state: String) -> void:
	if level.program != null:
		level.program.level_completed.disconnect(_change_state)
	level.verifier.verifications_started.disconnect(_change_state)
