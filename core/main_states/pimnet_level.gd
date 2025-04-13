# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	assert(Game.current_level != null)
	assert(_target.pimnet_level_screen != null)

	_target.unprepare_level_select()

	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%PimnetLevelContainer.move_to_front()

	Game.request_enter_level.connect(_enter_level)
	Game.request_load_level_select.connect(_load_level_select)
	Game.request_enter_level_select.connect(_change_state.bind("LevelSelect"))


func _load_level_select() -> void:
	# Only prepare if not already prepared
	var level_select = _target.level_select_screen
	if (
		level_select == null
		or level_select.current_map.focused_level.id != Game.current_level.id
	):
		_target.prepare_level_select()


func _enter_level(level_data: LevelResource) -> void:
	_target.prepare_pimnet_level(level_data)
	_change_state("PimnetLevel")


func _exit(_next_state: String) -> void:
	Game.request_enter_level.disconnect(_enter_level)
	Game.request_load_level_select.disconnect(_load_level_select)
	Game.request_enter_level_select.disconnect(_change_state)
