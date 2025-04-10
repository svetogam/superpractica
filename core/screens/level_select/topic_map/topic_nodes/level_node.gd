# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LevelNode
extends TopicNode

signal level_hinted(level_data)

var level_data: LevelResource


func _enter_tree() -> void:
	CSConnector.with(self).register("level_nodes")


func _ready() -> void:
	%MaskButton.button_down.connect(_on_button_down)


func _on_button_down() -> void:
	level_hinted.emit(level_data)


func setup(p_level_data: LevelResource) -> void:
	level_data = p_level_data
	id = level_data.id

	# Set title
	%MaskLabel.text = level_data.title
	if level_data.title.length() > 10:
		%MaskLabel.label_settings.font_size = 14
	else:
		%MaskLabel.label_settings.font_size = 16
	%OverviewLabel.text = level_data.title

	# Set progress
	if Game.progress_data.is_level_completed(id):
		%MaskCheckBox.button_pressed = true
		%OverviewCheckBox.button_pressed = true
	else:
		%MaskCheckBox.button_pressed = false
		%OverviewCheckBox.button_pressed = false


func set_thumbnail(viewport: SubViewport) -> void:
	%Thumbnail.texture = viewport.get_texture()


func get_thumbnail_rect() -> Rect2:
	return %Thumbnail.get_global_rect()
