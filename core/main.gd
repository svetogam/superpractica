# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node

const MainMenu := preload("uid://dtsgoie3mkpl")
const LevelSelect := preload("uid://c7261ypnucte8")
const PimnetLevel := preload("uid://2ert4t63mict")
var current_scene: Node
var prepared_level: Node
var prepared_level_select: Node


func _enter_tree() -> void:
	get_window().min_size = Vector2i(800, 600)
	get_window().max_size = Vector2i(1280, 800)
	CSLocator.with(self).register(
			Game.SERVICE_PIMNET_LEVEL_VIEWPORT, %PimnetLevelViewport)


func _ready() -> void:
	$StateMachine.activate()


func prepare_level_select() -> void:
	await Game.continue_as_coroutine()

	if prepared_level_select != null:
		# Abort if already prepared
		if prepared_level_select.current_map.topic_data.id == Game.current_level.id:
			return

		# Prepare again if need to prepare something different
		prepared_level_select.queue_free()

	prepared_level_select = LevelSelect.instantiate()
	%LevelSelectViewport.add_child(prepared_level_select)


func prepare_level(level_data: LevelResource) -> void:
	assert(level_data != null)

	await Game.continue_as_coroutine()

	if prepared_level != null:
		prepared_level.queue_free()

	Game.current_level = level_data
	prepared_level = PimnetLevel.instantiate()
	%PimnetLevelViewport.add_child(prepared_level)


func unprepare_level() -> void:
	await Game.continue_as_coroutine()

	if prepared_level != null:
		prepared_level.queue_free()

	Game.current_level = null


func exit_game() -> void:
	get_tree().quit()
