# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SubtopicNode
extends TopicNode

var topic_data: TopicResource
@onready var main_button := %MainButton as BaseButton:
	set(_value):
		assert(false)
@onready var mask := %Mask as Control:
	set(_value):
		assert(false)
@onready var overview := %Overview as Control:
	set(_value):
		assert(false)


func setup(p_topic_data: TopicResource) -> void:
	topic_data = p_topic_data
	id = topic_data.id

	# Set title
	%MaskLabel.text = topic_data.title
	%OverviewLabel.text = topic_data.title

	# Set progress
	var total_levels = topic_data.get_num_internals()
	var completed_levels = topic_data.get_num_completed_internals()
	#%MaskCheckBox.button_pressed = topic_data.is_completed()
	%OverviewProgressBar.max_value = total_levels
	%OverviewProgressBar.value = completed_levels
	%FractionLabel.text = str(completed_levels) + " / " + str(total_levels)


func set_thumbnail(viewport: SubViewport) -> void:
	%Thumbnail.texture = viewport.get_texture()


func get_thumbnail_rect() -> Rect2:
	return %Thumbnail.get_global_rect()
