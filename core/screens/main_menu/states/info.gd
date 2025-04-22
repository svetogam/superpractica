# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	%AboutBackButton.pressed.connect(_on_about_back_button_pressed)
	%CreditsButton.pressed.connect(_on_credits_button_pressed)


func _on_about_back_button_pressed() -> void:
	_change_state("FromAboutToStart")


func _on_credits_button_pressed() -> void:
	_change_state("FromAboutToCredits")


func _exit(_next_state: String) -> void:
	%AboutBackButton.pressed.disconnect(_on_about_back_button_pressed)
	%CreditsButton.pressed.disconnect(_on_credits_button_pressed)
