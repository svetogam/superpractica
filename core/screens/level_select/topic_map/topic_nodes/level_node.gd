# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

@tool # For drawing previews only
class_name LevelNode
extends TopicNode

var level_data: LevelResource
var completed := false:
	set(value):
		completed = value
		queue_redraw()
var suggested := false:
	set(value):
		suggested = value
		queue_redraw()


func _draw() -> void:
	var body_box: StyleBox
	var halo_box: StyleBox

	# Determine body
	if completed:
		body_box = box.get_theme_stylebox("completed")
	elif suggested:
		body_box = box.get_theme_stylebox("suggested")
	else:
		body_box = box.get_theme_stylebox("normal")

	# Determine halo
	if completed:
		halo_box = box.get_theme_stylebox("halo_thick")
	else:
		halo_box = box.get_theme_stylebox("halo_thin")

	# Draw
	draw_style_box(halo_box, box.get_rect())
	draw_style_box(body_box, box.get_rect())


func setup(p_level_data: LevelResource) -> void:
	level_data = p_level_data
	id = level_data.id
	%DetailLabel.text = level_data.title
	%MaskIcon.texture = level_data.get_icon_texture()
	completed = is_completed()


func is_completed() -> bool:
	return Game.progress_data.is_level_completed(id)
