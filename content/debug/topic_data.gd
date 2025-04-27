# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource

static var topic = TopicResource.new(
	# ID
	"debug_levels",
	# Title
	"Debug",
	# Background
	TopicMap.Backgrounds.BLUE_TRIANGLES,
	# Levels
	[
		LevelResource.new(
			# ID
			"grid_counting",
			# Title
			"Grid Counting Pim",
			# Icon
			LevelResource.LevelIcons.UNKNOWN,
			# Pimnet Setup
			preload("levels/grid_counting/pimnet_setup.tres"),
			# Goal Type
			# Program
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"slot_pims",
			# Title
			"Slot Pims",
			# Icon
			LevelResource.LevelIcons.UNKNOWN,
			# Pimnet Setup
			preload("levels/slot_pims/pimnet_setup.tres"),
			# Goal Type
			# Program
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"field_pims",
			# Title
			"Field Pims",
			# Icon
			LevelResource.LevelIcons.UNKNOWN,
			# Pimnet Setup
			preload("levels/field_pims/pimnet_setup.tres"),
			# Goal Type
			# Program
			# Program Vars
			# Program Plan
		),
	],
	# Subtopics
	[
		preload("selectors_topic_data.gd").topic,
	],
	# Layout
	preload("topic_layout.tscn"),
	# Connections
	[],
	# Groups
	[]
)
