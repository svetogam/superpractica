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
			"bubble_sum_1",
			# Scene
			preload("levels/bubble_sum/level.tscn"),
			# Title
			"Bubble Sum 1",
			# Thumbnail
			preload("levels/bubble_sum/thumbnail.png")
		),
		LevelResource.new(
			# ID
			"bubble_sum_2",
			# Scene
			preload("levels/bubble_sum_2/level.tscn"),
			# Title
			"2 Bubble Sum Pims",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"counting_board",
			# Scene
			preload("levels/counting_board/level.tscn"),
			# Title
			"Counting Board Pim",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"select_number_1",
			# Scene
			preload("levels/select_number_1/level.tscn"),
			# Title
			"Selector 1",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"select_number_2",
			# Scene
			preload("levels/select_number_2/level.tscn"),
			# Title
			"Selector 2",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"slot_pims",
			# Scene
			preload("levels/slot_pims/level.tscn"),
			# Title
			"Slot Pims",
			# Thumbnail
		),
		LevelResource.new(
			# ID
			"field_pims",
			# Scene
			preload("levels/field_pims/level.tscn"),
			# Title
			"Field Pims",
			# Thumbnail
		),
	],
	# Subtopics
	[
		preload("levels/sum_problems/topic_data.gd").topic,
		preload("res://core/level_select/tests/topic_data/topic_1.gd").topic,
	],
	# Layout
	preload("topic_layout.tscn"),
	# Connections
	[],
	# Groups
	[
		TopicGroupResource.new(
			["bubble_sum_1", "bubble_sum_2"]
		),
		TopicGroupResource.new(
			["select_number_1", "select_number_2"]
		),
	]
)
