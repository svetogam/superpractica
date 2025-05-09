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


func _enter_tree() -> void:
	get_window().min_size = Vector2i(800, 600)
	get_window().max_size = Vector2i(1280, 800)
	CSLocator.with(self).register(
			Game.SERVICE_PIMNET_LEVEL_VIEWPORT, %PimnetLevelViewport)


func _ready() -> void:
	$StateMachine.activate()


func prepare_main_menu() -> void:
	unprepare_main_menu()
	main_menu_screen = MainMenuScene.instantiate()
	%MainMenuViewport.add_child(main_menu_screen)


func unprepare_main_menu() -> void:
	if main_menu_screen != null:
		main_menu_screen.queue_free()


func prepare_level_select() -> void:
	unprepare_level_select()
	level_select_screen = LevelSelectScene.instantiate()
	%LevelSelectViewport.add_child(level_select_screen)


func unprepare_level_select() -> void:
	if level_select_screen != null:
		level_select_screen.queue_free()


func prepare_pimnet_level_screen() -> void:
	unprepare_pimnet_level_screen()

	pimnet_level_screen = PimnetLevelScene.instantiate()
	%PimnetLevelViewport.add_child(pimnet_level_screen)


func unprepare_pimnet_level_screen() -> void:
	if pimnet_level_screen != null:
		pimnet_level_screen.queue_free()
		CSLocator.with(self).unregister(Game.SERVICE_LEVEL_DATA)


func prepare_pimnet_level(level_data: LevelResource) -> void:
	assert(level_data != null)

	if pimnet_level_screen == null:
		prepare_pimnet_level_screen()
	unprepare_pimnet_level()

	pimnet_level_screen.load_level(level_data)
	CSLocator.with(self).register(Game.SERVICE_LEVEL_DATA, level_data)


func unprepare_pimnet_level() -> void:
	if pimnet_level_screen != null and pimnet_level_screen.level_data != null:
		pimnet_level_screen.unload_level()
		CSLocator.with(self).unregister(Game.SERVICE_LEVEL_DATA)


func exit_game() -> void:
	get_tree().quit()
