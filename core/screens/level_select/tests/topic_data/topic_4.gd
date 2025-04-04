# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource


static var topic = TopicResource.new(
	# ID
	"test_topic_4",
	# Title
	"Topic 4",
	# Levels
	[
		LevelResource.new(
			# ID
			"dummy_level_4_1",
			# Title
			"Level 4.1",
			# Pimnet Setup
			# Program
			# Program Vars
			# Program Plan
		),
	],
	# Subtopics
	[],
	# Layout
	preload("topic_4_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
