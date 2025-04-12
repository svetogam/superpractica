# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(last_state: String) -> void:
	match last_state:
		"MainMenu":
			_target.main_menu_screen.queue_free()

	if _target.level_select_screen != null:
		_target.level_select_screen.start_from_level()
	else:
		_target.level_select_screen = _target.LevelSelectScene.instantiate()
		%LevelSelectViewport.add_child(_target.level_select_screen)

	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%LevelSelectContainer.move_to_front()

	_target.level_select_screen.level_decided.connect(_target.prepare_level)
	_target.level_select_screen.level_undecided.connect(_target.unprepare_level)
	_target.level_select_screen.level_entered.connect(_on_level_entered)
	_target.level_select_screen.exit_pressed.connect(_change_state.bind("MainMenu"))
	Game.current_level = null


func _on_level_entered(level_data: LevelResource) -> void:
	Game.current_level = level_data
	_change_state("PimnetLevel")


func _exit(_next_state: String) -> void:
	pass
