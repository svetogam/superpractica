# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

static var selectors_topic = TopicResource.new(
	# ID
	"selectors",
	# Title
	"Selectors",
	# Background
	TopicMap.Backgrounds.BLUE_TRIANGLES,
	# Levels
	[
		LevelResource.new(
			# ID
			"select_number_1",
			# Title
			"Selector 1",
			# Icon
			LevelResource.TopicIcons.ONE,
			# Pimnet Setup
			preload("levels/number_selectors/select_number_1/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("level_programs/select_number_1.tscn"),
			# Program Vars
			{},
			# Program Plan
			preload("level_plans/select_number_1/plan_data.tres"),
		),
		LevelResource.new(
			# ID
			"select_number_2",
			# Title
			"Selector 2",
			# Icon
			LevelResource.TopicIcons.TWO,
			# Pimnet Setup
			preload("levels/number_selectors/select_number_2/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("level_programs/select_number_2.tscn"),
			# Program Vars
			{},
			# Program Plan
			preload("level_plans/select_number_2/plan_data.tres"),
		),
	],
	# Subtopics
	[],
	# Layout
	preload("topic_layouts/selectors.tscn"),
	# Connections
	[],
	# Groups
	[
		TopicGroupResource.new(
			["select_number_1", "select_number_2"]
		),
	]
)



static var root_topic = TopicResource.new(
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
			LevelResource.TopicIcons.UNKNOWN,
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
			LevelResource.TopicIcons.UNKNOWN,
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
			LevelResource.TopicIcons.UNKNOWN,
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
		selectors_topic,
	],
	# Layout
	preload("topic_layouts/pack_root.tscn"),
	# Connections
	[],
	# Groups
	[]
)
