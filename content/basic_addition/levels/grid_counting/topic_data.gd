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
			preload("grid_counting_a/variants/1_1.tscn"),
			# Title
			"1 - 1",
			# Thumbnail
			preload("grid_counting_a/variants/1_1_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_2",
			# Scene
			preload("grid_counting_a/variants/1_2.tscn"),
			# Title
			"1 - 2",
			# Thumbnail
			preload("grid_counting_a/variants/1_2_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_3",
			# Scene
			preload("grid_counting_b/variants/1_3.tscn"),
			# Title
			"1 - 3",
			# Thumbnail
			preload("grid_counting_b/variants/1_3_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_4",
			# Scene
			preload("grid_counting_b/variants/1_4.tscn"),
			# Title
			"1 - 4",
			# Thumbnail
			preload("grid_counting_b/variants/1_4_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_5",
			# Scene
			preload("grid_counting_b/variants/1_5.tscn"),
			# Title
			"1 - 5",
			# Thumbnail
			preload("grid_counting_b/variants/1_5_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_6",
			# Scene
			preload("grid_counting_b/variants/1_6.tscn"),
			# Title
			"1 - 6",
			# Thumbnail
			preload("grid_counting_b/variants/1_6_thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_random",
			# Scene
			preload("grid_counting_b/variants/1_random.tscn"),
			# Title
			"1 - Random",
			# Thumbnail
			preload("grid_counting_b/variants/1_random_thumbnail.png")
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
	]
)
