# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const MainMenu := preload("uid://dtsgoie3mkpl")
const LevelSelect := preload("uid://c7261ypnucte8")
const PimnetLevel := preload("uid://2ert4t63mict")
var _current_scene: Node
var _prepared_level: Node
var _prepared_level_select: Node


func _enter_tree() -> void:
	get_window().min_size = Vector2i(800, 600)
	get_window().max_size = Vector2i(1280, 800)
	CSLocator.with(self).register(
			Game.SERVICE_PIMNET_LEVEL_VIEWPORT, %PimnetLevelViewport)


func _ready() -> void:
	enter_main_menu()


func enter_main_menu() -> void:
	if _current_scene != null:
		_current_scene.queue_free()

	_current_scene = MainMenu.instantiate()
	%MainMenuViewport.add_child(_current_scene)

	%MainMenuContainer.show()
	%PimnetLevelContainer.hide()
	%LevelSelectContainer.hide()
	%MainMenuContainer.move_to_front()

	_current_scene.topics_pressed.connect(enter_level_select)
	_current_scene.exit_pressed.connect(exit_game)


func prepare_level_select() -> void:
	await Game.continue_as_coroutine()

	if _prepared_level_select != null:
		# Abort if already prepared
		if _prepared_level_select.current_map.topic_data.id == Game.current_level.id:
			return

		# Prepare again if need to prepare something different
		_prepared_level_select.queue_free()

	_prepared_level_select = LevelSelect.instantiate()
	%LevelSelectViewport.add_child(_prepared_level_select)


func enter_level_select() -> void:
	if _current_scene != null and _current_scene.name != "Level":
		_current_scene.queue_free()

	if _prepared_level_select != null:
		_current_scene = _prepared_level_select
		_prepared_level_select = null
		_current_scene.start_from_level()
	else:
		_current_scene = LevelSelect.instantiate()
		%LevelSelectViewport.add_child(_current_scene)

	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%LevelSelectContainer.move_to_front()

	_current_scene.level_decided.connect(prepare_level)
	_current_scene.level_undecided.connect(unprepare_level)
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


func unprepare_level() -> void:
	await Game.continue_as_coroutine()

	if _prepared_level != null:
		_prepared_level.queue_free()

	Game.current_level = null


func enter_level(level_data: LevelResource) -> void:
	assert(level_data != null)

	if _current_scene != null:
		_current_scene.queue_free()

	if _prepared_level != null:
		assert(Game.current_level == level_data)
		_current_scene = _prepared_level
	else:
		Game.current_level = level_data
		_current_scene = PimnetLevel.instantiate()
		%PimnetLevelViewport.add_child(_current_scene)

	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%PimnetLevelContainer.move_to_front()

	_current_scene.level_select_decided.connect(prepare_level_select)
	_current_scene.level_select_entered.connect(enter_level_select)
	_current_scene.next_level_entered.connect(_try_to_enter_next_level)


func exit_game() -> void:
	get_tree().quit()


func _try_to_enter_next_level() -> void:
	var next_level = Game.get_suggested_level_after_current()
	if next_level != null:
		enter_level(next_level)
