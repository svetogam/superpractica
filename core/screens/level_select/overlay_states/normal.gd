# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	%SystemButton.pressed.connect(_on_system_button_pressed)


func _on_system_button_pressed() -> void:
	_change_state("System")


func _exit(_next_state: String) -> void:
	%SystemButton.pressed.disconnect(_on_system_button_pressed)
