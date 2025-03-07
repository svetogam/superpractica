# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const MainMenu := preload("res://core/screens/main_menu/main_menu_screen.tscn")
const LevelSelect := preload("res://core/screens/level_select/level_select_screen.tscn")
const PimnetLevel := preload("res://core/screens/pimnet_level/pimnet_level_screen.tscn")
var _current_scene: Node = null


func _enter_tree() -> void:
	get_window().min_size = Vector2i(800, 600)
	get_window().max_size = Vector2i(1280, 800)


func _ready() -> void:
	enter_main_menu()


func enter_main_menu() -> void:
	if _current_scene != null:
		_current_scene.queue_free()

	_current_scene = MainMenu.instantiate()
	add_child(_current_scene)

	_current_scene.topics_pressed.connect(enter_level_select)
	_current_scene.exit_pressed.connect(exit_game)


func enter_level_select() -> void:
	if _current_scene != null:
		_current_scene.queue_free()

	_current_scene = LevelSelect.instantiate()
	add_child(_current_scene)

	_current_scene.level_entered.connect(enter_level)
	_current_scene.exit_pressed.connect(enter_main_menu)
	Game.current_level = null


func enter_level(level_data: LevelResource) -> void:
	assert(level_data != null)

	if _current_scene != null:
		_current_scene.queue_free()

	Game.current_level = level_data
	_current_scene = PimnetLevel.instantiate()
	add_child(_current_scene)

	_current_scene.exited_to_level_select.connect(enter_level_select)
	_current_scene.exited_to_next_level.connect(_try_to_enter_next_level)


func exit_game() -> void:
	get_tree().quit()


func _try_to_enter_next_level() -> void:
	var next_level = Game.get_suggested_level_after_current()
	if next_level != null:
		enter_level(next_level)
