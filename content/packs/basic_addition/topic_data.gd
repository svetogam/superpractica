# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource

static var topic = TopicResource.new(
	# ID
	"basic_addition",
	# Title
	"Basic Addition",
	# Levels
	[
	],
	# Subtopics
	[
		preload("levels/grid_counting/topic_data.gd").topic,
	],
	# Layout
	preload("topic_layout.tscn"),
	# Connections
	[
	],
	# Groups
	[
	]
)
