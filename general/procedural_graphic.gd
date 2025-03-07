# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

class_name ProceduralGraphic
extends Node2D


func set_properties(properties: Dictionary) -> void:
	for property in properties.keys():
		set(property, properties[property])

	queue_redraw()
