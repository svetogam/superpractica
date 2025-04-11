# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

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
			"grid_counting",
			# Title
			"Grid Counting Pim",
			# Pimnet Setup
			preload("levels/grid_counting/pimnet_setup.tres"),
			# Goal Type
			# Program
			# Program Vars
			# Program Plan
		),
		LevelResource.new(
			# ID
			"select_number_1",
			# Title
			"Selector 1",
			# Pimnet Setup
			preload("levels/number_selectors/select_number_1/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("levels/number_selectors/select_number_1/program.tscn"),
			# Program Vars
			null,
			# Program Plan
			preload("levels/number_selectors/select_number_1/plan/plan_data.tres"),
		),
		LevelResource.new(
			# ID
			"select_number_2",
			# Title
			"Selector 2",
			# Pimnet Setup
			preload("levels/number_selectors/select_number_2/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("levels/number_selectors/select_number_2/program.tscn"),
			# Program Vars
			null,
			# Program Plan
			preload("levels/number_selectors/select_number_2/plan/plan_data.tres"),
		),
		LevelResource.new(
			# ID
			"slot_pims",
			# Title
			"Slot Pims",
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
			# Pimnet Setup
			preload("levels/field_pims/pimnet_setup.tres"),
			# Goal Type
			# Program
			# Program Vars
			# Program Plan
		),
	],
	# Subtopics
	[],
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
