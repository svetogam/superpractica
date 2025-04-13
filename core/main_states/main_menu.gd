# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	_target.unprepare_level_select()
	_target.unprepare_pimnet_level()
	_target.prepare_main_menu()

	%MainMenuContainer.show()
	%PimnetLevelContainer.hide()
	%LevelSelectContainer.hide()
	%MainMenuContainer.move_to_front()

	Game.request_enter_level_select.connect(_change_state.bind("LevelSelect"))
	Game.request_exit_game.connect(_target.exit_game)


func _exit(_next_state: String) -> void:
	_target.unprepare_main_menu()

	Game.request_enter_level_select.disconnect(_change_state)
	Game.request_exit_game.disconnect(_target.exit_game)
