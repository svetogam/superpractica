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
	overlay.goal_panel.start_verification()
	level.pimnet.disable_verification_input(true)

	if level.program != null:
		level.program.level_completed.connect(_change_state.bind("Completed"))
	level.verifier.verifications_completed.connect(_change_state.bind("Playing"))


func _exit(_next_state: String) -> void:
	level.pimnet.disable_verification_input(false)
	if level.program != null:
		level.program.level_completed.disconnect(_change_state)
	level.verifier.verifications_completed.disconnect(_change_state)
