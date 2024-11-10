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
	"debug_levels",
	# Title
	"Debug",
	# Levels
	[
		LevelResource.new(
			# ID
			"bubble_sum",
			# Title
			"Bubble Sum Pim",
			# Thumbnail
			preload("levels/bubble_sum/thumbnail.png"),
			# Pimnet Setup
			preload("levels/bubble_sum/pimnet_setup.tres"),
			# Program
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting",
			# Title
			"Grid Counting Pim",
			# Thumbnail
			preload("levels/grid_counting/thumbnail.png"),
			# Pimnet Setup
			preload("levels/grid_counting/pimnet_setup.tres"),
			# Program
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"select_number_1",
			# Title
			"Selector 1",
			# Thumbnail
			preload("levels/number_selectors/select_number_1/thumbnail.png"),
			# Pimnet Setup
			preload("levels/number_selectors/select_number_1/pimnet_setup.tres"),
			# Program
			preload("levels/number_selectors/select_number_1/program.tscn"),
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"select_number_2",
			# Title
			"Selector 2",
			# Thumbnail
			preload("levels/number_selectors/select_number_2/thumbnail.png"),
			# Pimnet Setup
			preload("levels/number_selectors/select_number_2/pimnet_setup.tres"),
			# Program
			preload("levels/number_selectors/select_number_2/program.tscn"),
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"slot_pims",
			# Title
			"Slot Pims",
			# Thumbnail
			preload("levels/slot_pims/thumbnail.png"),
			# Pimnet Setup
			preload("levels/slot_pims/pimnet_setup.tres"),
			# Program
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"field_pims",
			# Title
			"Field Pims",
			# Thumbnail
			preload("levels/field_pims/thumbnail.png"),
			# Pimnet Setup
			preload("levels/field_pims/pimnet_setup.tres"),
			# Program
			# Program Vars
			# Program Plan
		),
	],
	# Subtopics
	[
		preload("levels/sum_problems/topic_data.gd").topic,
		preload("res://core/screens/level_select/tests/topic_data/topic_1.gd").topic,
	],
	# Layout
	preload("topic_layout.tscn"),
	# Connections
	[],
	# Groups
	[
		TopicGroupResource.new(
			["select_number_1", "select_number_2"]
		),
	]
)
