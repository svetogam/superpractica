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

	_target.pimnet_level_screen.level_select_decided.connect(_try_to_prepare_level_select)
	_target.pimnet_level_screen.level_select_entered.connect(
			_change_state.bind("LevelSelect"))
	_target.pimnet_level_screen.next_level_entered.connect(_try_to_enter_next_level)


func _try_to_prepare_level_select() -> void:
	# Only prepare if not already prepared
	var level_select = _target.level_select_screen
	if (
		level_select == null
		or level_select.current_map.focused_level.id != Game.current_level.id
	):
		_target.prepare_level_select()


func _try_to_enter_next_level() -> void:
	var next_level = Game.get_suggested_level_after_current()
	if next_level != null:
		_target.prepare_pimnet_level(next_level)
		_change_state("PimnetLevel")


func _exit(next_state: String) -> void:
	if next_state != "PimnetLevel":
		_target.pimnet_level_screen.level_select_decided.disconnect(
				_try_to_prepare_level_select)
		_target.pimnet_level_screen.level_select_entered.disconnect(_change_state)
		_target.pimnet_level_screen.next_level_entered.disconnect(
				_try_to_enter_next_level)
