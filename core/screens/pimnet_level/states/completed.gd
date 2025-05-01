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
	overlay.goal_panel.succeed()
	Game.progress_data.record_level_completion(level.level_data.id)
	%OverlayStateMachine.change_state("Completion")
