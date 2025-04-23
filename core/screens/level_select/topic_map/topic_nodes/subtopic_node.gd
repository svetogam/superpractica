# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name SubtopicNode
extends TopicNode

var topic_data: TopicResource


func setup(p_topic_data: TopicResource) -> void:
	topic_data = p_topic_data
	id = topic_data.id

	# Set title
	%MaskLabel.text = topic_data.title
	%DetailLabel.text = topic_data.title

	# Set progress
	var total_levels = topic_data.get_num_internals()
	var completed_levels = topic_data.get_num_completed_internals()
	#%MaskCheckBox.button_pressed = topic_data.is_completed()
	%DetailProgressBar.max_value = total_levels
	%DetailProgressBar.value = completed_levels
	%FractionLabel.text = str(completed_levels) + " / " + str(total_levels)
