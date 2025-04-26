# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

@tool # For drawing previews only
class_name SubtopicNode
extends TopicNode

var topic_data: TopicResource
var completed := false:
	set(value):
		completed = value
		queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	var body_box: StyleBox
	var halo_box := get_theme_stylebox("halo")

	# Determine body
	if completed:
		body_box = get_theme_stylebox("completed")
	else:
		body_box = get_theme_stylebox("normal")

	# Draw
	draw_style_box(halo_box, rect)
	draw_style_box(body_box, rect)


func setup(p_topic_data: TopicResource) -> void:
	topic_data = p_topic_data
	id = topic_data.id

	# Set title
	%MaskLabel.text = topic_data.title
	%DetailLabel.text = topic_data.title

	# Set progress
	var total_levels = topic_data.get_num_internals()
	var completed_levels = topic_data.get_num_completed_internals()
	completed = topic_data.is_completed()
	%DetailProgressBar.max_value = total_levels
	%DetailProgressBar.value = completed_levels
	%FractionLabel.text = str(completed_levels) + " / " + str(total_levels)
