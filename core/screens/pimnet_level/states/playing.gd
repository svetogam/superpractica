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
	match last_state:
		"Verifying":
			overlay.goal_panel.stop_verification()
			overlay.goal_panel.fail()

	if level.program != null:
		level.program.level_completed.connect(_change_state.bind("Completed"))
	level.verifier.started.connect(_change_state.bind("Verifying"))


func _exit(_next_state: String) -> void:
	if level.program != null:
		level.program.level_completed.disconnect(_change_state)
	level.verifier.started.disconnect(_change_state)
