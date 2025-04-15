# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(last_state: String) -> void:
	match last_state:
		"PimnetLevel":
			assert(_target.level_select_screen != null)
			_target.level_select_screen.start_from_level()
		"MainMenu":
			_target.prepare_level_select()
			_target.prepare_pimnet_level_screen()

	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%LevelSelectContainer.move_to_front()

	Game.request_load_level.connect(_target.prepare_pimnet_level)
	Game.request_unload_level.connect(_target.unprepare_pimnet_level)
	Game.request_enter_level.connect(_enter_level)
	Game.request_enter_main_menu.connect(_change_state.bind("MainMenu"))


func _enter_level(level_data: LevelResource) -> void:
	assert(level_data.id == _target.current_level_data.id)

	_change_state("PimnetLevel")


func _exit(_next_state: String) -> void:
	Game.request_load_level.disconnect(_target.prepare_pimnet_level)
	Game.request_unload_level.disconnect(_target.unprepare_pimnet_level)
	Game.request_enter_level.disconnect(_enter_level)
	Game.request_enter_main_menu.disconnect(_change_state)
