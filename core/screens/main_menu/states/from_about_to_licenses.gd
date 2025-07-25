# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	%TransitionCamera.transition_to(%LicensesCamera, _change_state.bind("Licenses"))


func _exit(_next_state: String) -> void:
	pass
