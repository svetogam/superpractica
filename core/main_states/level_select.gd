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

	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%LevelSelectContainer.move_to_front()

	_target.level_select_screen.level_decided.connect(_target.prepare_pimnet_level)
	_target.level_select_screen.level_undecided.connect(_target.unprepare_pimnet_level)
	_target.level_select_screen.level_entered.connect(_on_level_entered)
	_target.level_select_screen.exit_pressed.connect(_change_state.bind("MainMenu"))


func _on_level_entered(level_data: LevelResource) -> void:
	assert(level_data.id == Game.current_level.id)

	_change_state("PimnetLevel")


func _exit(_next_state: String) -> void:
	_target.level_select_screen.level_decided.disconnect(_target.prepare_pimnet_level)
	_target.level_select_screen.level_undecided.disconnect(_target.unprepare_pimnet_level)
	_target.level_select_screen.level_entered.disconnect(_on_level_entered)
	_target.level_select_screen.exit_pressed.disconnect(_change_state)
