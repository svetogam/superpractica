# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Panel

signal topics_pressed
signal exit_pressed


func _ready() -> void:
	if OS.get_name() == "Web":
		%QuitButton.hide()


func _on_topics_button_pressed() -> void:
	topics_pressed.emit()


func _on_about_button_pressed() -> void:
	%AboutPopup.show()


func _on_quit_button_pressed() -> void:
	exit_pressed.emit()
