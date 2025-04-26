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
	var rect := Rect2(Vector2.ZERO, size)
	var body_box: StyleBox
	var halo_box: StyleBox

	# Determine body
	if completed:
		body_box = get_theme_stylebox("completed")
	elif suggested:
		body_box = get_theme_stylebox("suggested")
	else:
		body_box = get_theme_stylebox("normal")

	# Determine halo
	if completed:
		halo_box = get_theme_stylebox("halo_thick")
	else:
		halo_box = get_theme_stylebox("halo_thin")

	# Draw
	draw_style_box(halo_box, rect)
	draw_style_box(body_box, rect)


func setup(p_level_data: LevelResource) -> void:
	level_data = p_level_data
	id = level_data.id

	%DetailLabel.text = level_data.title
	match level_data.icon:
		LevelResource.LevelIcons.ZERO:
			%MaskIcon.texture = get_theme_icon("0")
		LevelResource.LevelIcons.ONE:
			%MaskIcon.texture = get_theme_icon("1")
		LevelResource.LevelIcons.TWO:
			%MaskIcon.texture = get_theme_icon("2")
		LevelResource.LevelIcons.THREE:
			%MaskIcon.texture = get_theme_icon("3")
		LevelResource.LevelIcons.FOUR:
			%MaskIcon.texture = get_theme_icon("4")
		LevelResource.LevelIcons.FIVE:
			%MaskIcon.texture = get_theme_icon("5")
		LevelResource.LevelIcons.SIX:
			%MaskIcon.texture = get_theme_icon("6")
		LevelResource.LevelIcons.SEVEN:
			%MaskIcon.texture = get_theme_icon("7")
		LevelResource.LevelIcons.EIGHT:
			%MaskIcon.texture = get_theme_icon("8")
		LevelResource.LevelIcons.NINE:
			%MaskIcon.texture = get_theme_icon("9")
		LevelResource.LevelIcons.UNKNOWN:
			%MaskIcon.texture = get_theme_icon("unknown")

	completed = is_completed()


func is_completed() -> bool:
	return Game.progress_data.is_level_completed(id)
