# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	assert(Game.current_level != null)

	if _target.current_scene != null:
		_target.current_scene.queue_free()

	if _target.prepared_level != null:
		_target.current_scene = _target.prepared_level
	else:
		_target.current_scene = _target.PimnetLevel.instantiate()
		%PimnetLevelViewport.add_child(_target.current_scene)

	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%PimnetLevelContainer.move_to_front()

	_target.current_scene.level_select_decided.connect(_target.prepare_level_select)
	_target.current_scene.level_select_entered.connect(_change_state.bind("LevelSelect"))
	_target.current_scene.next_level_entered.connect(_try_to_enter_next_level)


func _try_to_enter_next_level() -> void:
	var next_level = Game.get_suggested_level_after_current()
	if next_level != null:
		Game.current_level = next_level
		_change_state("PimnetLevel")


func _exit(_next_state: String) -> void:
	pass
