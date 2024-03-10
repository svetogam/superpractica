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
			"2.1",
			# Scene
			preload("basic_addition_2/levels/level_1.tscn"),
			# Title
			"Addition 2",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"2.2",
			# Scene
			preload("basic_addition_2/levels/level_2.tscn"),
			# Title
			"Addition 2 Random",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"3.1",
			# Scene
			preload("basic_addition_3/levels/level_1.tscn"),
			# Title
			"Addition 3",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"3.2",
			# Scene
			preload("basic_addition_3/levels/level_2.tscn"),
			# Title
			"Addition 3 Random",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"4.1",
			# Scene
			preload("basic_addition_4/levels/level_1.tscn"),
			# Title
			"Addition 4",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"4.2",
			# Scene
			preload("basic_addition_4/levels/level_2.tscn"),
			# Title
			"Addition 4 Random",
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
		LevelResource.new(
			# ID
			"6.1",
			# Scene
			preload("basic_addition_6/levels/level_1.tscn"),
			# Title
			"Addition 6.1",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"6.2",
			# Scene
			preload("basic_addition_6/levels/level_2.tscn"),
			# Title
			"Addition 6.2",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"6.3",
			# Scene
			preload("basic_addition_6/levels/level_3.tscn"),
			# Title
			"Addition 6.3",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"6.4",
			# Scene
			preload("basic_addition_6/levels/level_4.tscn"),
			# Title
			"Addition 6 Random",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"7.1",
			# Scene
			preload("basic_addition_7/levels/level_1.tscn"),
			# Title
			"Addition 7.1",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"7.2",
			# Scene
			preload("basic_addition_7/levels/level_2.tscn"),
			# Title
			"Addition 7.2",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"7.3",
			# Scene
			preload("basic_addition_7/levels/level_3.tscn"),
			# Title
			"Addition 7.3",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"7.4",
			# Scene
			preload("basic_addition_7/levels/level_4.tscn"),
			# Title
			"Addition 7 Random",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"8.1",
			# Scene
			preload("basic_addition_8/levels/level_1.tscn"),
			# Title
			"Addition 8.1",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"8.2",
			# Scene
			preload("basic_addition_8/levels/level_2.tscn"),
			# Title
			"Addition 8.2",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"8.3",
			# Scene
			preload("basic_addition_8/levels/level_3.tscn"),
			# Title
			"Addition 8.3",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"8.4",
			# Scene
			preload("basic_addition_8/levels/level_4.tscn"),
			# Title
			"Addition 8 Random",
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
			"2.1", "2.2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"3.1", "3.2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"4.1", "4.2",
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
			"6.1", "6.2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"6.2", "6.3",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"6.3", "6.4",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"7.1", "7.2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"7.2", "7.3",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"7.3", "7.4",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"8.1", "8.2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"8.2", "8.3",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"8.3", "8.4",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"1.1", "2.1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		TopicConnectorResource.new(
			# IDs
			"2.1", "3.1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		TopicConnectorResource.new(
			# IDs
			"3.1", "4.1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		TopicConnectorResource.new(
			# IDs
			"4.1", "5.1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		TopicConnectorResource.new(
			# IDs
			"5.1", "6.1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		TopicConnectorResource.new(
			# IDs
			"6.1", "7.1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		TopicConnectorResource.new(
			# IDs
			"7.1", "8.1",
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
			["2.1", "2.2"]
		),
		TopicGroupResource.new(
			["3.1", "3.2"]
		),
		TopicGroupResource.new(
			["4.1", "4.2"]
		),
		TopicGroupResource.new(
			["5.1", "5.2", "5.3", "5.4"]
		),
		TopicGroupResource.new(
			["6.1", "6.2", "6.3", "6.4"]
		),
		TopicGroupResource.new(
			["7.1", "7.2", "7.3", "7.4"]
		),
		TopicGroupResource.new(
			["8.1", "8.2", "8.3", "8.4"]
		),
	]
)

