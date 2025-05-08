# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource

static var topic = TopicResource.new(
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
			# Icon
			LevelResource.TopicIcons.TWO,
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
	],
	# Subtopics
	[],
	# Layout
	preload("selectors_topic_layout.tscn"),
	# Connections
	[],
	# Groups
	[
		TopicGroupResource.new(
			["select_number_1", "select_number_2"]
		),
	]
)
