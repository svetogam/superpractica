# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const MainMenu := preload("uid://dtsgoie3mkpl")
const LevelSelect := preload("uid://c7261ypnucte8")
const PimnetLevel := preload("uid://2ert4t63mict")
var _current_scene: Node
var _prepared_level: Node


func _enter_tree() -> void:
	get_window().min_size = Vector2i(800, 600)
	get_window().max_size = Vector2i(1280, 800)
	CSLocator.with(self).register(
			Game.SERVICE_PIMNET_LEVEL_VIEWPORT, %PimnetLevelViewport)


func _ready() -> void:
	get_window().size_changed.connect(_on_window_size_changed)

	enter_main_menu()


func _on_window_size_changed() -> void:
	%PimnetLevelViewport.size = get_window().size


func enter_main_menu() -> void:
	if _current_scene != null:
		_current_scene.queue_free()

	_current_scene = MainMenu.instantiate()
	add_child(_current_scene)
	%PimnetLevelContainer.hide()

	_current_scene.topics_pressed.connect(enter_level_select)
	_current_scene.exit_pressed.connect(exit_game)


func enter_level_select() -> void:
	if _current_scene != null:
		_current_scene.queue_free()

	_current_scene = LevelSelect.instantiate()
	add_child(_current_scene)
	%PimnetLevelContainer.show()

	_current_scene.level_decided.connect(prepare_level)
	_current_scene.level_entered.connect(enter_level)
	_current_scene.exit_pressed.connect(enter_main_menu)
	Game.current_level = null


func prepare_level(level_data: LevelResource) -> void:
	assert(level_data != null)

	await Game.continue_as_coroutine()

	if _prepared_level != null:
		_prepared_level.queue_free()

	Game.current_level = level_data
	_prepared_level = PimnetLevel.instantiate()
	%PimnetLevelViewport.add_child(_prepared_level)


func enter_level(level_data: LevelResource) -> void:
	assert(level_data != null)

	if _current_scene != null:
		_current_scene.queue_free()

	if _prepared_level != null:
		assert(Game.current_level == level_data)
		_current_scene = _prepared_level
		_prepared_level = null
	else:
		Game.current_level = level_data
		_current_scene = PimnetLevel.instantiate()
		%PimnetLevelViewport.add_child(_current_scene)
	%PimnetLevelContainer.show()

	_current_scene.exited_to_level_select.connect(enter_level_select)
	_current_scene.exited_to_next_level.connect(_try_to_enter_next_level)


func exit_game() -> void:
	get_tree().quit()


func _try_to_enter_next_level() -> void:
	var next_level = Game.get_suggested_level_after_current()
	if next_level != null:
		enter_level(next_level)
