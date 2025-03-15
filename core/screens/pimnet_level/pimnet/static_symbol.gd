# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends TextureRect

var suggestion := Game.SuggestiveSignals.NONE:
	set(value):
		suggestion = value
		_update_colors()


func _update_colors() -> void:
	if suggestion == Game.SuggestiveSignals.AFFIRM:
		modulate = get_theme_color("affirm")
	elif suggestion == Game.SuggestiveSignals.WARN:
		modulate = get_theme_color("warn")
	elif suggestion == Game.SuggestiveSignals.REJECT:
		modulate = get_theme_color("warn")
	else:
		modulate = get_theme_color("normal")
