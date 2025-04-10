# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicNode
extends Control

var id: String
@onready var mask := %MaskContainer as SubViewportContainer:
	set(_value):
		assert(false)
@onready var mask_button := %MaskButton as BaseButton:
	set(_value):
		assert(false)
@onready var overview_panel := %OverviewPanel as Control:
	set(_value):
		assert(false)
@onready var overview_button := %OverviewButton as BaseButton:
	set(_value):
		assert(false)


# Virtual
func set_thumbnail(_viewport: SubViewport) -> void:
	pass


# Virtual
func get_thumbnail_rect() -> Rect2:
	return Rect2()
