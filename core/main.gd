# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const MainMenuScene := preload("uid://dtsgoie3mkpl")
const LevelSelectScene := preload("uid://c7261ypnucte8")
const PimnetLevelScene := preload("uid://2ert4t63mict")
var main_menu_screen: Panel
var level_select_screen: Node
var pimnet_level_screen: Level


func _enter_tree() -> void:
	get_window().min_size = Vector2i(800, 600)
	get_window().max_size = Vector2i(1280, 800)
	CSLocator.with(self).register(
			Game.SERVICE_PIMNET_LEVEL_VIEWPORT, %PimnetLevelViewport)


func _ready() -> void:
	$StateMachine.activate()


func prepare_level_select() -> void:
	await Game.continue_as_coroutine()

	if level_select_screen != null:
		# Abort if already prepared
		if level_select_screen.current_map.topic_data.id == Game.current_level.id:
			return

		# Prepare again if need to prepare something different
		level_select_screen.queue_free()

	level_select_screen = LevelSelectScene.instantiate()
	%LevelSelectViewport.add_child(level_select_screen)


func prepare_level(level_data: LevelResource) -> void:
	assert(level_data != null)

	await Game.continue_as_coroutine()

	if pimnet_level_screen != null:
		pimnet_level_screen.queue_free()

	Game.current_level = level_data
	pimnet_level_screen = PimnetLevelScene.instantiate()
	%PimnetLevelViewport.add_child(pimnet_level_screen)


func unprepare_level() -> void:
	await Game.continue_as_coroutine()

	if pimnet_level_screen != null:
		pimnet_level_screen.queue_free()

	Game.current_level = null


func exit_game() -> void:
	get_tree().quit()
