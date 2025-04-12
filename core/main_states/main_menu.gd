# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(last_state: String) -> void:
	match last_state:
		"LevelSelect":
			_target.level_select_screen.queue_free()

	_target.main_menu_screen = _target.MainMenuScene.instantiate()
	%MainMenuViewport.add_child(_target.main_menu_screen)

	%MainMenuContainer.show()
	%PimnetLevelContainer.hide()
	%LevelSelectContainer.hide()
	%MainMenuContainer.move_to_front()

	_target.main_menu_screen.topics_pressed.connect(_change_state.bind("LevelSelect"))
	_target.main_menu_screen.exit_pressed.connect(_target.exit_game)


func _exit(_next_state: String) -> void:
	pass
