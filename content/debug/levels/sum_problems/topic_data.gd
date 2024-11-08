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
			# Title
			"Addition 1",
			# Thumbnail
			null,
			# Pimnet Setup
			preload("basic_addition_1/pimnet_setup.tres"),
			# Program
			preload("basic_addition_1/program.tscn"),
			# Program Vars
			preload("basic_addition_1/levels/level_1.tres"),
			# Program Plan
			preload("basic_addition_1/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"debug_1_1_2",
			# Title
			"Addition 1 Random",
			# Thumbnail
			null,
			# Pimnet Setup
			preload("basic_addition_1/pimnet_setup.tres"),
			# Program
			preload("basic_addition_1/program.tscn"),
			# Program Vars
			preload("basic_addition_1/levels/level_2.tres"),
			# Program Plan
			preload("basic_addition_1/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"debug_1_5_1",
			# Title
			"Addition 5.1",
			# Thumbnail
			null,
			# Pimnet Setup
			preload("basic_addition_5/pimnet_setup.tres"),
			# Program
			preload("basic_addition_5/program.tscn"),
			# Program Vars
			preload("basic_addition_5/levels/level_1.tres"),
			# Program Plan
			preload("basic_addition_5/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"debug_1_5_2",
			# Title
			"Addition 5.2",
			# Thumbnail
			null,
			# Pimnet Setup
			preload("basic_addition_5/pimnet_setup.tres"),
			# Program
			preload("basic_addition_5/program.tscn"),
			# Program Vars
			preload("basic_addition_5/levels/level_2.tres"),
			# Program Plan
			preload("basic_addition_5/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"debug_1_5_3",
			# Title
			"Addition 5.3",
			# Thumbnail
			null,
			# Pimnet Setup
			preload("basic_addition_5/pimnet_setup.tres"),
			# Program
			preload("basic_addition_5/program.tscn"),
			# Program Vars
			preload("basic_addition_5/levels/level_3.tres"),
			# Program Plan
			preload("basic_addition_5/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"debug_1_5_4",
			# Title
			"Addition 5 Random",
			# Thumbnail
			null,
			# Pimnet Setup
			preload("basic_addition_5/pimnet_setup.tres"),
			# Program
			preload("basic_addition_5/program.tscn"),
			# Program Vars
			preload("basic_addition_5/levels/level_4.tres"),
			# Program Plan
			preload("basic_addition_5/plan_data.tres")
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
