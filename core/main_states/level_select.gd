# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	match _last_state:
		"MainMenu":
			_target.current_scene.queue_free()

	if _target.prepared_level_select != null:
		_target.current_scene = _target.prepared_level_select
		_target.prepared_level_select = null
		_target.current_scene.start_from_level()
	else:
		_target.current_scene = _target.LevelSelect.instantiate()
		%LevelSelectViewport.add_child(_target.current_scene)

	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%LevelSelectContainer.move_to_front()

	_target.current_scene.level_decided.connect(_target.prepare_level)
	_target.current_scene.level_undecided.connect(_target.unprepare_level)
	_target.current_scene.level_entered.connect(_on_level_entered)
	_target.current_scene.exit_pressed.connect(_change_state.bind("MainMenu"))
	Game.current_level = null


func _on_level_entered(level_data: LevelResource) -> void:
	Game.current_level = level_data
	_change_state("PimnetLevel")


func _exit(_next_state: String) -> void:
	pass
