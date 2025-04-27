# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Resource

static var topic = TopicResource.new(
	# ID
	"grid_counting",
	# Title
	"Grid Counting",
	# Background
	TopicMap.Backgrounds.GREEN_TRIANGLES,
	# Levels
	[
		LevelResource.new(
			# ID
			"grid_counting_0_1",
			# Title
			"Intro - 1",
			# Icon
			LevelResource.LevelIcons.ONE,
			# Pimnet Setup
			preload("grid_counting_d/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("grid_counting_d/program.tscn"),
			# Program Vars
			preload("grid_counting_d/variants/0_1.tres"),
			# Program Plan
			preload("grid_counting_d/plan/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_0_2",
			# Title
			"Intro - 2",
			# Icon
			LevelResource.LevelIcons.TWO,
			# Pimnet Setup
			preload("grid_counting_e/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("grid_counting_e/program.tscn"),
			# Program Vars
			preload("grid_counting_e/variants/0_2.tres"),
			# Program Plan
			preload("grid_counting_e/plan/plan_data.tres")
		),


		LevelResource.new(
			# ID
			"grid_counting_1_1",
			# Title
			"1 - 1",
			# Icon
			LevelResource.LevelIcons.ONE,
			# Pimnet Setup
			preload("grid_counting_a/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("grid_counting_a/program.tscn"),
			# Program Vars
			preload("grid_counting_a/variants/1_1.tres"),
			# Program Plan
			preload("grid_counting_a/plan/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_2",
			# Title
			"1 - 2",
			# Icon
			LevelResource.LevelIcons.TWO,
			# Pimnet Setup
			preload("grid_counting_a/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("grid_counting_a/program.tscn"),
			# Program Vars
			preload("grid_counting_a/variants/1_2.tres"),
			# Program Plan
			preload("grid_counting_a/plan/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_3",
			# Title
			"1 - 3",
			# Icon
			LevelResource.LevelIcons.THREE,
			# Pimnet Setup
			preload("grid_counting_b/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("grid_counting_b/program.tscn"),
			# Program Vars
			preload("grid_counting_b/variants/1_3.tres"),
			# Program Plan
			preload("grid_counting_b/plan/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_4",
			# Title
			"1 - 4",
			# Icon
			LevelResource.LevelIcons.FOUR,
			# Pimnet Setup
			preload("grid_counting_b/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("grid_counting_b/program.tscn"),
			# Program Vars
			preload("grid_counting_b/variants/1_4.tres"),
			# Program Plan
			preload("grid_counting_b/plan/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_5",
			# Title
			"1 - 5",
			# Icon
			LevelResource.LevelIcons.FIVE,
			# Pimnet Setup
			preload("grid_counting_b/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("grid_counting_b/program.tscn"),
			# Program Vars
			preload("grid_counting_b/variants/1_5.tres"),
			# Program Plan
			preload("grid_counting_b/plan/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_6",
			# Title
			"1 - 6",
			# Icon
			LevelResource.LevelIcons.SIX,
			# Pimnet Setup
			preload("grid_counting_b/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("grid_counting_b/program.tscn"),
			# Program Vars
			preload("grid_counting_b/variants/1_6.tres"),
			# Program Plan
			preload("grid_counting_b/plan/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_random",
			# Title
			"1 - Random",
			# Icon
			LevelResource.LevelIcons.UNKNOWN,
			# Pimnet Setup
			preload("grid_counting_b/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.HINTED_MEMO_SLOT,
			# Program
			preload("grid_counting_b/program.tscn"),
			# Program Vars
			preload("grid_counting_b/variants/1_random.tres"),
			# Program Plan
			preload("grid_counting_b/plan/plan_data.tres")
		),


		LevelResource.new(
			# ID
			"grid_counting_2_1",
			# Title
			"2 - 1",
			# Icon
			LevelResource.LevelIcons.ONE,
			# Pimnet Setup
			preload("grid_counting_f/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
			# Program
			preload("grid_counting_f/program.tscn"),
			# Program Vars
			preload("grid_counting_f/variants/2_1.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_2",
			# Title
			"2 - 2",
			# Icon
			LevelResource.LevelIcons.TWO,
			# Pimnet Setup
			preload("grid_counting_f/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
			# Program
			preload("grid_counting_f/program.tscn"),
			# Program Vars
			preload("grid_counting_f/variants/2_2.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_3",
			# Title
			"2 - 3",
			# Icon
			LevelResource.LevelIcons.THREE,
			# Pimnet Setup
			preload("grid_counting_f/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
			# Program
			preload("grid_counting_f/program.tscn"),
			# Program Vars
			preload("grid_counting_f/variants/2_3.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_4",
			# Title
			"2 - 4",
			# Icon
			LevelResource.LevelIcons.FOUR,
			# Pimnet Setup
			preload("grid_counting_f/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
			# Program
			preload("grid_counting_f/program.tscn"),
			# Program Vars
			preload("grid_counting_f/variants/2_4.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_5",
			# Title
			"2 - 5",
			# Icon
			LevelResource.LevelIcons.FIVE,
			# Pimnet Setup
			preload("grid_counting_f/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
			# Program
			preload("grid_counting_f/program.tscn"),
			# Program Vars
			preload("grid_counting_f/variants/2_5.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_6",
			# Title
			"2 - 6",
			# Icon
			LevelResource.LevelIcons.SIX,
			# Pimnet Setup
			preload("grid_counting_f/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
			# Program
			preload("grid_counting_f/program.tscn"),
			# Program Vars
			preload("grid_counting_f/variants/2_6.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_7",
			# Title
			"2 - 7",
			# Icon
			LevelResource.LevelIcons.SEVEN,
			# Pimnet Setup
			preload("grid_counting_f/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
			# Program
			preload("grid_counting_f/program.tscn"),
			# Program Vars
			preload("grid_counting_f/variants/2_7.tres"),
			# Program Plan
		),


		LevelResource.new(
			# ID
			"grid_counting_3_1",
			# Title
			"3 - 1",
			# Icon
			LevelResource.LevelIcons.ONE,
			# Pimnet Setup
			preload("grid_counting_c/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_c/program.tscn"),
			# Program Vars
			preload("grid_counting_c/variants/3_1.tres"),
			# Program Plan
			null
		),
		LevelResource.new(
			# ID
			"grid_counting_3_2",
			# Title
			"3 - 2",
			# Icon
			LevelResource.LevelIcons.TWO,
			# Pimnet Setup
			preload("grid_counting_c/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_c/program.tscn"),
			# Program Vars
			preload("grid_counting_c/variants/3_2.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_3_3",
			# Title
			"3 - 3",
			# Icon
			LevelResource.LevelIcons.THREE,
			# Pimnet Setup
			preload("grid_counting_c/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_c/program.tscn"),
			# Program Vars
			preload("grid_counting_c/variants/3_3.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_3_4",
			# Title
			"3 - 4",
			# Icon
			LevelResource.LevelIcons.FOUR,
			# Pimnet Setup
			preload("grid_counting_c/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_c/program.tscn"),
			# Program Vars
			preload("grid_counting_c/variants/3_4.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_3_5",
			# Title
			"3 - 5",
			# Icon
			LevelResource.LevelIcons.FIVE,
			# Pimnet Setup
			preload("grid_counting_c/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_c/program.tscn"),
			# Program Vars
			preload("grid_counting_c/variants/3_5.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_3_6",
			# Title
			"3 - 6",
			# Icon
			LevelResource.LevelIcons.SIX,
			# Pimnet Setup
			preload("grid_counting_c/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_c/program.tscn"),
			# Program Vars
			preload("grid_counting_c/variants/3_6.tres"),
			# Program Plan
		),


		LevelResource.new(
			# ID
			"grid_counting_4_1",
			# Title
			"4 - 1",
			# Icon
			LevelResource.LevelIcons.ONE,
			# Pimnet Setup
			preload("grid_counting_g/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_g/program.tscn"),
			# Program Vars
			preload("grid_counting_g/variants/4_1.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_2",
			# Title
			"4 - 2",
			# Icon
			LevelResource.LevelIcons.TWO,
			# Pimnet Setup
			preload("grid_counting_g/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_g/program.tscn"),
			# Program Vars
			preload("grid_counting_g/variants/4_2.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_3",
			# Title
			"4 - 3",
			# Icon
			LevelResource.LevelIcons.THREE,
			# Pimnet Setup
			preload("grid_counting_g/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_g/program.tscn"),
			# Program Vars
			preload("grid_counting_g/variants/4_3.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_4",
			# Title
			"4 - 4",
			# Icon
			LevelResource.LevelIcons.FOUR,
			# Pimnet Setup
			preload("grid_counting_g/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_g/program.tscn"),
			# Program Vars
			preload("grid_counting_g/variants/4_4.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_5",
			# Title
			"4 - 5",
			# Icon
			LevelResource.LevelIcons.FIVE,
			# Pimnet Setup
			preload("grid_counting_g/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_g/program.tscn"),
			# Program Vars
			preload("grid_counting_g/variants/4_5.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_6",
			# Title
			"4 - 6",
			# Icon
			LevelResource.LevelIcons.SIX,
			# Pimnet Setup
			preload("grid_counting_g/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_g/program.tscn"),
			# Program Vars
			preload("grid_counting_g/variants/4_6.tres"),
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_random",
			# Title
			"4 - Random",
			# Icon
			LevelResource.LevelIcons.UNKNOWN,
			# Pimnet Setup
			preload("grid_counting_g/pimnet_setup.tres"),
			# Goal Type
			LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
			# Program
			preload("grid_counting_g/program.tscn"),
			# Program Vars
			preload("grid_counting_g/variants/4_random.tres"),
			# Program Plan
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
			"grid_counting_0_1", "grid_counting_0_2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),


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


		TopicConnectorResource.new(
			# IDs
			"grid_counting_2_1", "grid_counting_2_2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_2_2", "grid_counting_2_3",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_2_3", "grid_counting_2_4",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_2_4", "grid_counting_2_5",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_2_5", "grid_counting_2_6",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_2_6", "grid_counting_2_7",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),


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


		TopicConnectorResource.new(
			# IDs
			"grid_counting_4_1", "grid_counting_4_2",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_4_2", "grid_counting_4_3",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_4_3", "grid_counting_4_4",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_4_4", "grid_counting_4_5",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_4_5", "grid_counting_4_6",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_4_6", "grid_counting_4_random",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.RIGHT
		),


		TopicConnectorResource.new(
			# IDs
			"grid_counting_0_2", "grid_counting_1_1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_1_random", "grid_counting_2_1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.RIGHT
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_1_random", "grid_counting_3_1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_2_7", "grid_counting_4_1",
			# Directions
			Utils.Direction.DOWN, Utils.Direction.DOWN
		),
		TopicConnectorResource.new(
			# IDs
			"grid_counting_3_6", "grid_counting_4_1",
			# Directions
			Utils.Direction.RIGHT, Utils.Direction.DOWN
		),
	],


	# Groups
	[
		TopicGroupResource.new(
			[
				"grid_counting_0_1",
				"grid_counting_0_2",
			]
		),
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
		TopicGroupResource.new(
			[
				"grid_counting_2_1",
				"grid_counting_2_2",
				"grid_counting_2_3",
				"grid_counting_2_4",
				"grid_counting_2_5",
				"grid_counting_2_6",
				"grid_counting_2_7",
			]
		),
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
		TopicGroupResource.new(
			[
				"grid_counting_4_1",
				"grid_counting_4_2",
				"grid_counting_4_3",
				"grid_counting_4_4",
				"grid_counting_4_5",
				"grid_counting_4_6",
				"grid_counting_4_random",
			]
		),
	],


	# Suggested Order
	[
		"grid_counting_0_1",
		"grid_counting_0_2",
		"grid_counting_1_1",
		"grid_counting_1_2",
		"grid_counting_1_3",
		"grid_counting_1_4",
		"grid_counting_1_5",
		"grid_counting_1_6",
		"grid_counting_1_random",
		"grid_counting_2_1",
		"grid_counting_2_2",
		"grid_counting_2_3",
		"grid_counting_2_4",
		"grid_counting_2_5",
		"grid_counting_2_6",
		"grid_counting_2_7",
		"grid_counting_3_1",
		"grid_counting_3_2",
		"grid_counting_3_3",
		"grid_counting_3_4",
		"grid_counting_3_5",
		"grid_counting_3_6",
		"grid_counting_4_1",
		"grid_counting_4_2",
		"grid_counting_4_3",
		"grid_counting_4_4",
		"grid_counting_4_5",
		"grid_counting_4_6",
		"grid_counting_4_random",
	]
)
