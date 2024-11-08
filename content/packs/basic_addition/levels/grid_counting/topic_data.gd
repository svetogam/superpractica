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
	"grid_counting",
	# Title
	"Grid Counting",
	# Levels
	[
		LevelResource.new(
			# ID
			"grid_counting_1_1",
			# Scene
			preload("grid_counting_a/level.tscn"),
			# Title
			"1 - 1",
			# Program Vars
			preload("grid_counting_a/variants/1_1.tres"),
			# Thumbnail
			preload("grid_counting_a/variants/1_1_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_2",
			# Scene
			preload("grid_counting_a/level.tscn"),
			# Title
			"1 - 2",
			# Program Vars
			preload("grid_counting_a/variants/1_2.tres"),
			# Thumbnail
			preload("grid_counting_a/variants/1_2_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_3",
			# Scene
			preload("grid_counting_b/level.tscn"),
			# Title
			"1 - 3",
			# Program Vars
			preload("grid_counting_b/variants/1_3.tres"),
			# Thumbnail
			preload("grid_counting_b/variants/1_3_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_4",
			# Scene
			preload("grid_counting_b/level.tscn"),
			# Title
			"1 - 4",
			# Program Vars
			preload("grid_counting_b/variants/1_4.tres"),
			# Thumbnail
			preload("grid_counting_b/variants/1_4_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_5",
			# Scene
			preload("grid_counting_b/level.tscn"),
			# Title
			"1 - 5",
			# Program Vars
			preload("grid_counting_b/variants/1_5.tres"),
			# Thumbnail
			preload("grid_counting_b/variants/1_5_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_6",
			# Scene
			preload("grid_counting_b/level.tscn"),
			# Title
			"1 - 6",
			# Program Vars
			preload("grid_counting_b/variants/1_6.tres"),
			# Thumbnail
			preload("grid_counting_b/variants/1_6_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_random",
			# Scene
			preload("grid_counting_b/level.tscn"),
			# Title
			"1 - Random",
			# Program Vars
			preload("grid_counting_b/variants/1_random.tres"),
			# Thumbnail
			preload("grid_counting_b/variants/1_random_thumbnail.png")
		),


		#LevelResource.new(
			## ID
			#"grid_counting_2_1",
			## Scene
			#null,
			## Title
			#"2 - 1",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_2_2",
			## Scene
			#null,
			## Title
			#"2 - 2",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_2_3",
			## Scene
			#null,
			## Title
			#"2 - 3",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_2_4",
			## Scene
			#null,
			## Title
			#"2 - 4",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_2_5",
			## Scene
			#null,
			## Title
			#"2 - 5",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_2_6",
			## Scene
			#null,
			## Title
			#"2 - 6",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_2_7",
			## Scene
			#null,
			## Title
			#"2 - 7",
			## Thumbnail
			#null
		#),


		LevelResource.new(
			# ID
			"grid_counting_3_1",
			# Scene
			preload("grid_counting_c/level.tscn"),
			# Title
			"3 - 1",
			# Program Vars
			preload("grid_counting_c/variants/3_1.tres"),
			# Thumbnail
			preload("grid_counting_c/variants/3_1_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_3_2",
			# Scene
			preload("grid_counting_c/level.tscn"),
			# Title
			"3 - 2",
			# Program Vars
			preload("grid_counting_c/variants/3_2.tres"),
			# Thumbnail
			preload("grid_counting_c/variants/3_2_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_3_3",
			# Scene
			preload("grid_counting_c/level.tscn"),
			# Title
			"3 - 3",
			# Program Vars
			preload("grid_counting_c/variants/3_3.tres"),
			# Thumbnail
			preload("grid_counting_c/variants/3_3_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_3_4",
			# Scene
			preload("grid_counting_c/level.tscn"),
			# Title
			"3 - 4",
			# Program Vars
			preload("grid_counting_c/variants/3_4.tres"),
			# Thumbnail
			preload("grid_counting_c/variants/3_4_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_3_5",
			# Scene
			preload("grid_counting_c/level.tscn"),
			# Title
			"3 - 5",
			# Program Vars
			preload("grid_counting_c/variants/3_5.tres"),
			# Thumbnail
			preload("grid_counting_c/variants/3_5_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_3_6",
			# Scene
			preload("grid_counting_c/level.tscn"),
			# Title
			"3 - 6",
			# Program Vars
			preload("grid_counting_c/variants/3_6.tres"),
			# Thumbnail
			preload("grid_counting_c/variants/3_6_thumbnail.png")
		),


		#LevelResource.new(
			## ID
			#"grid_counting_4_1",
			## Scene
			#null,
			## Title
			#"4 - 1",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_4_2",
			## Scene
			#null,
			## Title
			#"4 - 2",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_4_3",
			## Scene
			#null,
			## Title
			#"4 - 3",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_4_4",
			## Scene
			#null,
			## Title
			#"4 - 4",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_4_5",
			## Scene
			#null,
			## Title
			#"4 - 5",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_4_6",
			## Scene
			#null,
			## Title
			#"4 - 6",
			## Thumbnail
			#null
		#),
		#LevelResource.new(
			## ID
			#"grid_counting_4_random",
			## Scene
			#null,
			## Title
			#"4 - Random",
			## Thumbnail
			#null
		#),
	],


	# Subtopics
	[],


	# Layout
	preload("topic_layout.tscn"),


	# Connections
	[
		TopicConnectorResource.new(
			# IDs
			"grid_counting_1_1", "grid_counting_1_2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_1_2", "grid_counting_1_3",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_1_3", "grid_counting_1_4",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_1_4", "grid_counting_1_5",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_1_5", "grid_counting_1_6",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_1_6", "grid_counting_1_random",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),


		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_2_1", "grid_counting_2_2",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_2_2", "grid_counting_2_3",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_2_3", "grid_counting_2_4",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_2_4", "grid_counting_2_5",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_2_5", "grid_counting_2_6",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_2_6", "grid_counting_2_7",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),


		TopicConnectorResource.new(
			# IDs
			"grid_counting_3_1", "grid_counting_3_2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_3_2", "grid_counting_3_3",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_3_3", "grid_counting_3_4",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_3_4", "grid_counting_3_5",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_3_5", "grid_counting_3_6",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),


		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_4_1", "grid_counting_4_2",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_4_2", "grid_counting_4_3",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_4_3", "grid_counting_4_4",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_4_4", "grid_counting_4_5",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_4_5", "grid_counting_4_6",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_4_6", "grid_counting_4_random",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.RIGHT
		#),


		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_1_random", "grid_counting_2_1",
			## Directions
			#Utils.Direction.DOWN, Utils.Direction.RIGHT
		#),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_1_random", "grid_counting_3_1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_2_7", "grid_counting_4_1",
			## Directions
			#Utils.Direction.DOWN, Utils.Direction.DOWN
		#),
		#TopicConnectorResource.new(
			## IDs
			#"grid_counting_3_6", "grid_counting_4_1",
			## Directions
			#Utils.Direction.RIGHT, Utils.Direction.DOWN
		#),
	],


	# Groups
	[
		TopicGroupResource.new(
			[
				"grid_counting_1_1",
				"grid_counting_1_2",
				"grid_counting_1_3",
				"grid_counting_1_4",
				"grid_counting_1_5",
				"grid_counting_1_6",
				"grid_counting_1_random",
			]
		),
		#TopicGroupResource.new(
			#[
				#"grid_counting_2_1",
				#"grid_counting_2_2",
				#"grid_counting_2_3",
				#"grid_counting_2_4",
				#"grid_counting_2_5",
				#"grid_counting_2_6",
				#"grid_counting_2_7",
			#]
		#),
		TopicGroupResource.new(
			[
				"grid_counting_3_1",
				"grid_counting_3_2",
				"grid_counting_3_3",
				"grid_counting_3_4",
				"grid_counting_3_5",
				"grid_counting_3_6",
			]
		),
		#TopicGroupResource.new(
			#[
				#"grid_counting_4_1",
				#"grid_counting_4_2",
				#"grid_counting_4_3",
				#"grid_counting_4_4",
				#"grid_counting_4_5",
				#"grid_counting_4_6",
				#"grid_counting_4_random",
			#]
		#),
	],


	# Suggested Order
	[
		"grid_counting_1_1",
		"grid_counting_1_2",
		"grid_counting_1_3",
		"grid_counting_1_4",
		"grid_counting_1_5",
		"grid_counting_1_6",
		"grid_counting_1_random",
		#"grid_counting_2_1",
		#"grid_counting_2_2",
		#"grid_counting_2_3",
		#"grid_counting_2_4",
		#"grid_counting_2_5",
		#"grid_counting_2_6",
		#"grid_counting_2_7",
		"grid_counting_3_1",
		"grid_counting_3_2",
		"grid_counting_3_3",
		"grid_counting_3_4",
		"grid_counting_3_5",
		"grid_counting_3_6",
		#"grid_counting_4_1",
		#"grid_counting_4_2",
		#"grid_counting_4_3",
		#"grid_counting_4_4",
		#"grid_counting_4_5",
		#"grid_counting_4_6",
		#"grid_counting_4_random",
	]
)
