# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicGroup
extends Panel


func setup(rect: Rect2, icon := LevelResource.LevelIcons.UNKNOWN) -> void:
	position = rect.position
	size = rect.size
	match icon:
		LevelResource.LevelIcons.ZERO:
			%IconRect.texture = get_theme_icon("0")
		LevelResource.LevelIcons.ONE:
			%IconRect.texture = get_theme_icon("1")
		LevelResource.LevelIcons.TWO:
			%IconRect.texture = get_theme_icon("2")
		LevelResource.LevelIcons.THREE:
			%IconRect.texture = get_theme_icon("3")
		LevelResource.LevelIcons.FOUR:
			%IconRect.texture = get_theme_icon("4")
		LevelResource.LevelIcons.FIVE:
			%IconRect.texture = get_theme_icon("5")
		LevelResource.LevelIcons.SIX:
			%IconRect.texture = get_theme_icon("6")
		LevelResource.LevelIcons.SEVEN:
			%IconRect.texture = get_theme_icon("7")
		LevelResource.LevelIcons.EIGHT:
			%IconRect.texture = get_theme_icon("8")
		LevelResource.LevelIcons.NINE:
			%IconRect.texture = get_theme_icon("9")
		LevelResource.LevelIcons.UNKNOWN:
			%IconRect.texture = get_theme_icon("unknown")
