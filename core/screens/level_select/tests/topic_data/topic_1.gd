# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource


static var topic = TopicResource.new(
	# ID
	"test_topic_1",
	# Title
	"Test Topics",
	# Levels
	[
		LevelResource.new(
			# ID
			"dummy_level_1_1",
			# Title
			"Level 1.1",
			# Pimnet Setup
			# Program
			# Program Vars
			# Program Plan
		),
	],
	# Subtopics
	[
		preload("topic_2.gd").topic,
		preload("topic_3.gd").topic,
	],
	# Layout
	preload("topic_1_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
