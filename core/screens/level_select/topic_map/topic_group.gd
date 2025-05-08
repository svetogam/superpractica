# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name TopicGroup
extends Panel

var group_data: TopicGroupResource


func setup(p_group_data: TopicGroupResource, rect: Rect2) -> void:
	group_data = p_group_data
	position = rect.position
	size = rect.size
	%IconRect.texture = group_data.get_icon_texture()
