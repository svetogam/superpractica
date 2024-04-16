#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Resource

static var topic = TopicResource.new(
	# ID
	"sum_problems",
	# Title
	"Sum Problems",
	# Levels
	[
		LevelResource.new(
			# ID
			"1.1",
			# Scene
			preload("basic_addition_1/levels/level_1.tscn"),
			# Title
			"Addition 1",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"1.2",
			# Scene
			preload("basic_addition_1/levels/level_2.tscn"),
			# Title
			"Addition 1 Random",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"5.1",
			# Scene
			preload("basic_addition_5/levels/level_1.tscn"),
			# Title
			"Addition 5.1",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"5.2",
			# Scene
			preload("basic_addition_5/levels/level_2.tscn"),
			# Title
			"Addition 5.2",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"5.3",
			# Scene
			preload("basic_addition_5/levels/level_3.tscn"),
			# Title
			"Addition 5.3",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"5.4",
			# Scene
			preload("basic_addition_5/levels/level_4.tscn"),
			# Title
			"Addition 5 Random",
			# Thumbnail
		),
	],
	# Subtopics
	[],
	# Layout
	preload("topic_layout.tscn"),
	# Connections
	[
		TopicConnectorResource.new(
			# IDs
			"1.1", "1.2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"5.1", "5.2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"5.2", "5.3",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"5.3", "5.4",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"1.1", "5.1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
	],
	# Groups
	[
		TopicGroupResource.new(
			["1.1", "1.2"]
		),
		TopicGroupResource.new(
			["5.1", "5.2", "5.3", "5.4"]
		),
	]
)
