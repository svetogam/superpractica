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
	"debug_1",
	# Title
	"Sum Problems",
	# Levels
	[
		LevelResource.new(
			# ID
			"debug_1_1_1",
			# Scene
			preload("basic_addition_1/level.tscn"),
			# Title
			"Addition 1",
			# Program Vars
			preload("basic_addition_1/levels/level_1.tres"),
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"debug_1_1_2",
			# Scene
			preload("basic_addition_1/level.tscn"),
			# Title
			"Addition 1 Random",
			# Program Vars
			preload("basic_addition_1/levels/level_2.tres"),
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"debug_1_5_1",
			# Scene
			preload("basic_addition_5/level.tscn"),
			# Title
			"Addition 5.1",
			# Program Vars
			preload("basic_addition_5/levels/level_1.tres"),
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"debug_1_5_2",
			# Scene
			preload("basic_addition_5/level.tscn"),
			# Title
			"Addition 5.2",
			# Program Vars
			preload("basic_addition_5/levels/level_2.tres"),
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"debug_1_5_3",
			# Scene
			preload("basic_addition_5/level.tscn"),
			# Title
			"Addition 5.3",
			# Program Vars
			preload("basic_addition_5/levels/level_3.tres"),
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"debug_1_5_4",
			# Scene
			preload("basic_addition_5/level.tscn"),
			# Title
			"Addition 5 Random",
			# Program Vars
			preload("basic_addition_5/levels/level_4.tres"),
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
			"debug_1_1_1", "debug_1_1_2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"debug_1_5_1", "debug_1_5_2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"debug_1_5_2", "debug_1_5_3",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"debug_1_5_3", "debug_1_5_4",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"debug_1_1_1", "debug_1_5_1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
	],
	# Groups
	[
		TopicGroupResource.new(
			["debug_1_1_1", "debug_1_1_2"]
		),
		TopicGroupResource.new(
			["debug_1_5_1", "debug_1_5_2", "debug_1_5_3", "debug_1_5_4"]
		),
	],
	# Suggested Order
	[
		"debug_1_1_1",
		"debug_1_5_1",
		"debug_1_5_2",
		"debug_1_5_3",
	]
)
