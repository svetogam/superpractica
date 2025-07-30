# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Node


func _ready() -> void:
	Game.root_topic = preload("root_topic_data.gd").root_topic
