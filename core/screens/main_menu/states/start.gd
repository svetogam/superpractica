# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	%TopicsButton.pressed.connect(_on_topics_button_pressed)
	%InfoButton.pressed.connect(_on_info_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func _on_topics_button_pressed() -> void:
	Game.request_enter_level_select.emit()


func _on_info_button_pressed() -> void:
	_change_state("FromStartToAbout")


func _on_quit_button_pressed() -> void:
	Game.request_exit_game.emit()


func _exit(_next_state: String) -> void:
	%TopicsButton.pressed.disconnect(_on_topics_button_pressed)
	%InfoButton.pressed.disconnect(_on_info_button_pressed)
	%QuitButton.pressed.disconnect(_on_quit_button_pressed)
