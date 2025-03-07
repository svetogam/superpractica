# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource


static var topic = TopicResource.new(
	# ID
	"root",
	# Title
	"Topics",
	# Levels
	[],
	# Subtopics
	[
		preload("packs/basic_addition/topic_data.gd").topic,
		preload("debug/topic_data.gd").topic,
	],
	# Layout
	preload("root_topic_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
