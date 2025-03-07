# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends ColorRect

@onready var label := %Label as Label


func _ready() -> void:
	global_position = get_global_mouse_position()


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()

	if not get_viewport().gui_is_dragging():
		queue_free()
