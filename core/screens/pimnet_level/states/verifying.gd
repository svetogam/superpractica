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
		PimnetOverlay.GoalPanels.SOLUTION_MEMO_SLOTS:
			overlay.goal_panel.open_verification_panel()
			overlay.goal_panel.solution_slot.set_highlight(
					MemoSlot.HighlightTypes.REGULAR)

	level.pimnet.disable_verification_input(true)
	if level.program != null:
		level.program.level_completed.connect(_change_state.bind("Completed"))
	level.verifier.verifications_completed.connect(_change_state.bind("Playing"))


func _exit(_next_state: String) -> void:
	level.pimnet.disable_verification_input(false)
	if level.program != null:
		level.program.level_completed.disconnect(_change_state)
	level.verifier.verifications_completed.disconnect(_change_state)
