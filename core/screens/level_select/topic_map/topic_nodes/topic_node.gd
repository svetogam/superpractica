# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicNode
extends Control

var id: String


# Virtual
func set_thumbnail(_viewport: SubViewport) -> void:
	pass


# Virtual
func get_thumbnail_rect() -> Rect2:
	return Rect2()
