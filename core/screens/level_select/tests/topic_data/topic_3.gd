# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource


static var topic = TopicResource.new(
	# ID
	"test_topic_3",
	# Title
	"Topic 3",
	# Levels
	[],
	# Subtopics
	[
		preload("topic_4.gd").topic,
	],
	# Layout
	preload("topic_3_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
