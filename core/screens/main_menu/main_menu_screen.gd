# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Panel


func _ready() -> void:
	if OS.get_name() == "Web":
		%QuitButton.hide()


func _on_topics_button_pressed() -> void:
	Game.request_enter_level_select.emit()


func _on_about_button_pressed() -> void:
	%AboutPopup.show()


func _on_quit_button_pressed() -> void:
	Game.request_exit_game.emit()
