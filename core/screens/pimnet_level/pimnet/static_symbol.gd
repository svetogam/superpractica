# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

@tool # For drawing previews only
extends Control

var suggestion := Game.SuggestiveSignals.NONE:
	set(value):
		suggestion = value
		queue_redraw()


func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	var box: StyleBox
	if suggestion == Game.SuggestiveSignals.AFFIRM:
		box = get_theme_stylebox("panel_affirm")
	elif suggestion == Game.SuggestiveSignals.WARN:
		box = get_theme_stylebox("panel_warn")
	elif suggestion == Game.SuggestiveSignals.REJECT:
		box = get_theme_stylebox("panel_warn")
	else:
		box = get_theme_stylebox("panel")

	draw_style_box(box, rect)
