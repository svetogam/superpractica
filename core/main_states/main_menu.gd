# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State


func _enter(_last_state: String) -> void:
	if _target.current_scene != null:
		_target.current_scene.queue_free()

	_target.current_scene = _target.MainMenu.instantiate()
	%MainMenuViewport.add_child(_target.current_scene)

	%MainMenuContainer.show()
	%PimnetLevelContainer.hide()
	%LevelSelectContainer.hide()
	%MainMenuContainer.move_to_front()

	_target.current_scene.topics_pressed.connect(_change_state.bind("LevelSelect"))
	_target.current_scene.exit_pressed.connect(_target.exit_game)


func _exit(_next_state: String) -> void:
	pass
