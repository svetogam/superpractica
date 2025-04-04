# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource


static var topic = TopicResource.new(
	# ID
	"test_topic_2",
	# Title
	"Topic 2",
	# Levels
	[
		LevelResource.new(
			# ID
			"dummy_level_2_1",
			# Title
			"Level 2.1",
			# Pimnet Setup
			# Program
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"dummy_level_2_2",
			# Title
			"Level 2.2",
			# Pimnet Setup
			# Program
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"dummy_level_2_3",
			# Title
			"Level 2.3",
			# Pimnet Setup
			# Program
			# Program Vars
			# Program Plan
		),
	],
	# Subtopics
	[],
	# Layout
	preload("topic_2_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
