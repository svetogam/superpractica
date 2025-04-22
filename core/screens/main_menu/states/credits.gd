# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	%CreditsBackButton.pressed.connect(_on_credits_back_button_pressed)


func _on_credits_back_button_pressed() -> void:
	_change_state("FromCreditsToAbout")


func _exit(_next_state: String) -> void:
	%CreditsBackButton.pressed.disconnect(_on_credits_back_button_pressed)
