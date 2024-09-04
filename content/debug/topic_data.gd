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
			# Scene
			preload("levels/bubble_sum/level.tscn"),
			# Title
			"Bubble Sum Pim",
			# Thumbnail
			preload("levels/bubble_sum/thumbnail.png")
		),
		LevelResource.new(
			# ID
			"grid_counting",
			# Scene
			preload("levels/grid_counting/level.tscn"),
			# Title
			"Grid Counting Pim",
			# Thumbnail
			preload("levels/grid_counting/thumbnail.png")
		),
		LevelResource.new(
			# ID
			"select_number_1",
			# Scene
			preload("levels/number_selectors/select_number_1/level.tscn"),
			# Title
			"Selector 1",
			# Thumbnail
			preload("levels/number_selectors/select_number_1/thumbnail.png")
		),
		LevelResource.new(
			# ID
			"select_number_2",
			# Scene
			preload("levels/number_selectors/select_number_2/level.tscn"),
			# Title
			"Selector 2",
			# Thumbnail
			preload("levels/number_selectors/select_number_2/thumbnail.png")
		),
		LevelResource.new(
			# ID
			"slot_pims",
			# Scene
			preload("levels/slot_pims/level.tscn"),
			# Title
			"Slot Pims",
			# Thumbnail
			preload("levels/slot_pims/thumbnail.png")
		),
		LevelResource.new(
			# ID
			"field_pims",
			# Scene
			preload("levels/field_pims/level.tscn"),
			# Title
			"Field Pims",
			# Thumbnail
			preload("levels/field_pims/thumbnail.png")
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
