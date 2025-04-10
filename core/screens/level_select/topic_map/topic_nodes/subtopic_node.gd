# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SubtopicNode
extends TopicNode

var topic_data: TopicResource


func setup(value: TopicResource) -> void:
	topic_data = value
	id = topic_data.id

	# Set title
	%MaskLabel.text = topic_data.title
	if topic_data.title.length() > 10:
		%MaskLabel.label_settings.font_size = 14
	else:
		%MaskLabel.label_settings.font_size = 16
	%OverviewLabel.text = topic_data.title

	# Set progress
	var total_levels = topic_data.get_num_internals()
	var completed_levels = topic_data.get_num_completed_internals()
	%MaskProgressBar.max_value = total_levels
	%MaskProgressBar.value = completed_levels
	%MaskCheckBox.button_pressed = topic_data.is_completed()
	%OverviewProgressBar.max_value = total_levels
	%OverviewProgressBar.value = completed_levels
	%FractionLabel.text = str(completed_levels) + " / " + str(total_levels)


func set_thumbnail(viewport: SubViewport) -> void:
	%Thumbnail.texture = viewport.get_texture()


func get_thumbnail_rect() -> Rect2:
	return %Thumbnail.get_global_rect()
