# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const MainMenuScene := preload("uid://dtsgoie3mkpl")
const LevelSelectScene := preload("uid://c7261ypnucte8")
const PimnetLevelScene := preload("uid://2ert4t63mict")
var main_menu_screen: Control
var level_select_screen: Node
var pimnet_level_screen: Level
var current_level_data: LevelResource:
	get:
		if pimnet_level_screen != null and pimnet_level_screen.level_data != null:
			return pimnet_level_screen.level_data
		return null
var new_level_data: LevelResource


func _enter_tree() -> void:
	get_window().min_size = Vector2i(800, 600)
	get_window().max_size = Vector2i(1280, 800)


func _ready() -> void:
	CSLocator.with(self).register(
		Game.SERVICE_PIMNET_LEVEL_VIEWPORT, %PimnetLevelViewport
	)

	Game.request_enter_main_menu.connect(_on_request_enter_main_menu)
	Game.request_load_level_select.connect(_on_request_load_level_select)
	Game.request_enter_level_select.connect(_on_request_enter_level_select)
	Game.request_load_level.connect(_on_request_load_level)
	Game.request_unload_level.connect(_on_request_unload_level)
	Game.request_enter_level.connect(_on_request_enter_level)
	Game.request_exit_game.connect(_on_request_exit_game)


func _on_request_enter_main_menu() -> void:
	$StateChart.send_event("enter_main_menu")


func _on_request_load_level_select() -> void:
	if (
		not $StateChart/Screens/LevelSelect/Prepared.active
		or level_select_screen.current_map.focused_level.id != current_level_data.id
	):
		$StateChart.send_event("prepare_level_select")


func _on_request_enter_level_select() -> void:
	$StateChart.send_event("enter_level_select")


func _on_request_load_level(level_data: LevelResource) -> void:
	assert($StateChart/Screens/PimnetLevel/ScreenPrepared.active)

	if $StateChart/Screens/Current/LevelSelect.active:
		new_level_data = level_data
		$StateChart.send_event("load_pimnet_level_data")


func _on_request_unload_level() -> void:
	if $StateChart/Screens/Current/LevelSelect.active:
		$StateChart.send_event("unload_pimnet_level_data")


func _on_request_enter_level(level_data: LevelResource) -> void:
	if $StateChart/Screens/Current/LevelSelect.active:
		assert(level_data.id == current_level_data.id)
		$StateChart.send_event("enter_pimnet_level")
	elif $StateChart/Screens/Current/PimnetLevel.active:
		new_level_data = level_data
		$StateChart.send_event("load_pimnet_level_data")
		$StateChart.send_event("enter_pimnet_level")


func _on_request_exit_game() -> void:
	if $StateChart/Screens/Current/MainMenu.active:
		get_tree().quit()


func _on_main_menu_state_entered() -> void:
	$StateChart.send_event("unprepare_level_select")
	$StateChart.send_event("unprepare_pimnet_level_screen")
	$StateChart.send_event("prepare_main_menu")

	%MainMenuContainer.show()
	%PimnetLevelContainer.hide()
	%LevelSelectContainer.hide()
	%MainMenuContainer.move_to_front()


func _on_main_menu_state_exited() -> void:
	$StateChart.send_event("unprepare_main_menu")


func _on_level_select_state_entered() -> void:
	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%LevelSelectContainer.move_to_front()


func _on_pimnet_level_state_entered() -> void:
	assert(current_level_data != null)

	%MainMenuContainer.hide()
	%PimnetLevelContainer.show()
	%LevelSelectContainer.show()
	%PimnetLevelContainer.move_to_front()

	$StateChart.send_event.call_deferred("unprepare_level_select")
	Game.level_entered.emit()


func _on_main_menu_to_level_select_taken() -> void:
	$StateChart.send_event("prepare_level_select")
	$StateChart.send_event("prepare_pimnet_level_screen")


func _on_pimnet_level_to_level_select_taken() -> void:
	assert(level_select_screen != null)

	level_select_screen.start_from_level()


func _on_main_menu_prepared_state_entered() -> void:
	assert(main_menu_screen == null)

	main_menu_screen = MainMenuScene.instantiate()
	%MainMenuViewport.add_child(main_menu_screen)


func _on_main_menu_prepared_state_exited() -> void:
	assert(main_menu_screen != null)

	main_menu_screen.queue_free()
	main_menu_screen = null


func _on_level_select_prepared_state_entered() -> void:
	assert(level_select_screen == null)

	level_select_screen = LevelSelectScene.instantiate()
	%LevelSelectViewport.add_child(level_select_screen)


func _on_level_select_prepared_state_exited() -> void:
	assert(level_select_screen != null)

	level_select_screen.queue_free()
	level_select_screen = null


func _on_pimnet_level_screen_prepared_state_entered() -> void:
	assert(pimnet_level_screen == null)

	pimnet_level_screen = PimnetLevelScene.instantiate()
	%PimnetLevelViewport.add_child(pimnet_level_screen)


func _on_pimnet_level_screen_prepared_state_exited() -> void:
	assert(pimnet_level_screen != null)

	pimnet_level_screen.queue_free()
	pimnet_level_screen = null
	CSLocator.with(self).unregister(Game.SERVICE_LEVEL_DATA)


func _on_pimnet_level_data_loaded_state_entered() -> void:
	assert(pimnet_level_screen != null)
	assert(new_level_data != null)

	pimnet_level_screen.load_level(new_level_data)
	CSLocator.with(self).register(Game.SERVICE_LEVEL_DATA, new_level_data)
	new_level_data = null


func _on_pimnet_level_data_loaded_state_exited() -> void:
	assert(pimnet_level_screen != null)
	assert(pimnet_level_screen.level_data != null)

	pimnet_level_screen.unload_level()
	CSLocator.with(self).unregister(Game.SERVICE_LEVEL_DATA)
