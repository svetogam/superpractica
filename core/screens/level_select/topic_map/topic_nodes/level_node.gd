# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LevelNode
extends TopicNode

var level_data: LevelResource


func _ready() -> void:
	super()
	%MainButton.button_down.connect(_on_button_down)


func _on_button_down() -> void:
	Game.request_load_level.emit(level_data)


func setup(p_level_data: LevelResource) -> void:
	level_data = p_level_data
	id = level_data.id

	# Set title
	%MaskLabel.text = level_data.title
	%DetailLabel.text = level_data.title

	# Set progress
	if Game.progress_data.is_level_completed(id):
		%DetailCheckBox.button_pressed = true
	else:
		%DetailCheckBox.button_pressed = false
