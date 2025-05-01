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
	if overlay.goal_panel != null:
		overlay.goal_panel.reset()
	if level.verifier.is_running():
		level.verifier.abort()
		level.pimnet.disable_verification_input(false)


func _exit(_next_state: String) -> void:
	pass
