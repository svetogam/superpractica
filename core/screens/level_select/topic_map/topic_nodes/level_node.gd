# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LevelNode
extends TopicNode

var level_data: LevelResource
@onready var main_button := %MainButton as BaseButton:
	set(_value):
		assert(false)
@onready var mask := %Mask as Control:
	set(_value):
		assert(false)
@onready var overview := %Overview as Control:
	set(_value):
		assert(false)


func _ready() -> void:
	%MainButton.button_down.connect(_on_button_down)


func _on_button_down() -> void:
	Game.request_load_level.emit(level_data)


func setup(p_level_data: LevelResource) -> void:
	level_data = p_level_data
	id = level_data.id

	# Set title
	%MaskLabel.text = level_data.title
	%OverviewLabel.text = level_data.title

	# Set progress
	if Game.progress_data.is_level_completed(id):
		%OverviewCheckBox.button_pressed = true
	else:
		%OverviewCheckBox.button_pressed = false


func set_thumbnail(viewport: SubViewport) -> void:
	%Thumbnail.texture = viewport.get_texture()


func get_thumbnail_rect() -> Rect2:
	return %Thumbnail.get_global_rect()
