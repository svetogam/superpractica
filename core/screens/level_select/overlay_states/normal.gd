# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	_target.zooming_started.connect(_on_zooming_started)
	_target.zooming_stopped.connect(_on_zooming_stopped)
	%SystemButton.pressed.connect(_on_system_button_pressed)


func _on_zooming_started() -> void:
	%SystemButton.disabled = true


func _on_zooming_stopped() -> void:
	%SystemButton.disabled = false


func _on_system_button_pressed() -> void:
	_change_state("System")


func _exit(_next_state: String) -> void:
	_target.zooming_started.disconnect(_on_zooming_started)
	_target.zooming_stopped.disconnect(_on_zooming_stopped)
	%SystemButton.pressed.disconnect(_on_system_button_pressed)
