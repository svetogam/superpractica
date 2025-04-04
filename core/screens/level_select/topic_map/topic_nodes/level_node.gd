# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LevelNode
extends TopicNode

signal level_hinted(level_data)

var level_data: LevelResource
var _level_viewport: SubViewport


func _enter_tree() -> void:
	CSLocator.with(self).connect_service_found(
			Game.SERVICE_PIMNET_LEVEL_VIEWPORT, _on_level_viewport_found)
	CSConnector.with(self).register("level_nodes")


func _ready() -> void:
	%MaskButton.button_down.connect(_on_button_down)


func _on_level_viewport_found(p_level_viewport: SubViewport) -> void:
	_level_viewport = p_level_viewport
	%Thumbnail.texture.viewport_path = _level_viewport.get_path()
	if not _level_viewport.child_entered_tree.is_connected(update_thumbnail):
		_level_viewport.child_entered_tree.connect(update_thumbnail.unbind(1))


func _on_button_down() -> void:
	level_hinted.emit(level_data)


func update_thumbnail() -> void:
	if _level_viewport != null and _level_viewport.get_child_count() > 0:
		%Thumbnail.show()
		%ThumbnailPlaceholder.hide()
	else:
		%Thumbnail.hide()
		%ThumbnailPlaceholder.show()


func setup(value: LevelResource) -> void:
	level_data = value
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
