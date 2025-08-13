# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

static var grid_counting_topic = TopicResource.new(
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
			"1 - 1",
			# Icon
			LevelResource.TopicIcons.ONE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.HINTED_MEMO_SLOT,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
			},
			# Program
			preload("level_programs/grid_counting_d.tscn"),
			# Program Vars
			{
				"number": 5,
			},
			# Program Plan
			preload("level_plans/grid_counting_d/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_0_2",
			# Title
			"1 - 2",
			# Icon
			LevelResource.TopicIcons.TWO,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.HINTED_MEMO_SLOT,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_e.tscn"),
			# Program Vars
			{
				"count": 1,
			},
			# Program Plan
			preload("level_plans/grid_counting_e/plan_data.tres")
		),


		LevelResource.new(
			# ID
			"grid_counting_1_1",
			# Title
			"2 - 1",
			# Icon
			LevelResource.TopicIcons.ONE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.HINTED_MEMO_SLOT,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_a.tscn"),
			# Program Vars
			{
				"count": 3,
			},
			# Program Plan
			preload("level_plans/grid_counting_a/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_2",
			# Title
			"2 - 2",
			# Icon
			LevelResource.TopicIcons.TWO,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.HINTED_MEMO_SLOT,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_a.tscn"),
			# Program Vars
			{
				"count": 6,
			},
			# Program Plan
			preload("level_plans/grid_counting_a/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_3",
			# Title
			"2 - 3",
			# Icon
			LevelResource.TopicIcons.THREE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.HINTED_MEMO_SLOT,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_b.tscn"),
			# Program Vars
			{
				"count": 30,
			},
			# Program Plan
			preload("level_plans/grid_counting_b/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_4",
			# Title
			"2 - 4",
			# Icon
			LevelResource.TopicIcons.FOUR,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.HINTED_MEMO_SLOT,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_b.tscn"),
			# Program Vars
			{
				"count": 22,
			},
			# Program Plan
			preload("level_plans/grid_counting_b/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_5",
			# Title
			"2 - 5",
			# Icon
			LevelResource.TopicIcons.FIVE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.HINTED_MEMO_SLOT,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_b.tscn"),
			# Program Vars
			{
				"count": 54,
			},
			# Program Plan
			preload("level_plans/grid_counting_b/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_6",
			# Title
			"2 - 6",
			# Icon
			LevelResource.TopicIcons.SIX,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.HINTED_MEMO_SLOT,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_b.tscn"),
			# Program Vars
			{
				"count": 100,
			},
			# Program Plan
			preload("level_plans/grid_counting_b/plan_data.tres")
		),
		LevelResource.new(
			# ID
			"grid_counting_1_random",
			# Title
			"2 - Random",
			# Icon
			LevelResource.TopicIcons.UNKNOWN,
			# Pimnet Data
			{
				"level_type": LevelResource.LevelTypes.TRIAL_PRACTICE,
				"number_trials": 5,
				"time_limit": 40.0,
				"goal_type": LevelResource.GoalTypes.HINTED_MEMO_SLOT,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_b.tscn"),
			# Program Vars
			{
				"min_count": 1,
				"max_count": 50,
			},
			# Program Plan
			preload("level_plans/grid_counting_b/plan_data.tres")
		),


		LevelResource.new(
			# ID
			"grid_counting_2_1",
			# Title
			"3 - 1",
			# Icon
			LevelResource.TopicIcons.ONE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_f.tscn"),
			# Program Vars
			{
				"sum": 7,
				"object_count": 4,
				"allowed_objects": [
					"unit",
					"two_block",
					"ten_block",
				]
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_2",
			# Title
			"3 - 2",
			# Icon
			LevelResource.TopicIcons.TWO,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_f.tscn"),
			# Program Vars
			{
				"sum": 9,
				"object_count": 3,
				"allowed_objects": [
					"unit",
					"two_block",
					"three_block",
					"ten_block",
				]
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_3",
			# Title
			"3 - 3",
			# Icon
			LevelResource.TopicIcons.THREE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_f.tscn"),
			# Program Vars
			{
				"sum": 30,
				"object_count": 5,
				"allowed_objects": [
					"unit",
					"two_block",
					"three_block",
					"four_block",
					"ten_block",
				]
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_4",
			# Title
			"3 - 4",
			# Icon
			LevelResource.TopicIcons.FOUR,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_f.tscn"),
			# Program Vars
			{
				"sum": 19,
				"object_count": 3,
				"allowed_objects": [
					"unit",
					"two_block",
					"three_block",
					"four_block",
					"five_block",
					"ten_block",
				]
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_5",
			# Title
			"3 - 5",
			# Icon
			LevelResource.TopicIcons.FIVE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_f.tscn"),
			# Program Vars
			{
				"sum": 50,
				"object_count": 3,
				"allowed_objects": [
					"unit",
					"two_block",
					"three_block",
					"four_block",
					"five_block",
					"ten_block",
					"twenty_block",
				]
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_6",
			# Title
			"3 - 6",
			# Icon
			LevelResource.TopicIcons.SIX,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_f.tscn"),
			# Program Vars
			{
				"sum": 72,
				"object_count": 3,
				"allowed_objects": [
					"unit",
					"two_block",
					"three_block",
					"four_block",
					"five_block",
					"ten_block",
					"twenty_block",
					"thirty_block",
					"forty_block",
				]
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_2_7",
			# Title
			"3 - 7",
			# Icon
			LevelResource.TopicIcons.SEVEN,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.CONSTRUCT_CONDITIONS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_f.tscn"),
			# Program Vars
			{
				"sum": 99,
				"object_count": 4,
				"allowed_objects": [
					"unit",
					"two_block",
					"three_block",
					"four_block",
					"five_block",
					"ten_block",
					"twenty_block",
					"thirty_block",
					"forty_block",
					"fifty_block",
				]
			},
			# Program Plan
		),


		LevelResource.new(
			# ID
			"grid_counting_3_1",
			# Title
			"4 - 1",
			# Icon
			LevelResource.TopicIcons.ONE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_c.tscn"),
			# Program Vars
			{
				"addend_1": 2,
				"addend_2": 1,
			},
			# Program Plan
			null
		),
		LevelResource.new(
			# ID
			"grid_counting_3_2",
			# Title
			"4 - 2",
			# Icon
			LevelResource.TopicIcons.TWO,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_c.tscn"),
			# Program Vars
			{
				"addend_1": 4,
				"addend_2": 4,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_3_3",
			# Title
			"4 - 3",
			# Icon
			LevelResource.TopicIcons.THREE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_c.tscn"),
			# Program Vars
			{
				"addend_1": 3,
				"addend_2": 8,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_3_4",
			# Title
			"4 - 4",
			# Icon
			LevelResource.TopicIcons.FOUR,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_c.tscn"),
			# Program Vars
			{
				"addend_1": 10,
				"addend_2": 6,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_3_5",
			# Title
			"4 - 5",
			# Icon
			LevelResource.TopicIcons.FIVE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_c.tscn"),
			# Program Vars
			{
				"addend_1": 2,
				"addend_2": 39,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_3_6",
			# Title
			"4 - 6",
			# Icon
			LevelResource.TopicIcons.SIX,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_c.tscn"),
			# Program Vars
			{
				"addend_1": 1,
				"addend_2": 0,
			},
			# Program Plan
		),


		LevelResource.new(
			# ID
			"grid_counting_4_1",
			# Title
			"5 - 1",
			# Icon
			LevelResource.TopicIcons.ONE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_g.tscn"),
			# Program Vars
			{
				"addend_1": 7,
				"addend_2": 8,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_2",
			# Title
			"5 - 2",
			# Icon
			LevelResource.TopicIcons.TWO,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_g.tscn"),
			# Program Vars
			{
				"addend_1": 20,
				"addend_2": 30,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_3",
			# Title
			"5 - 3",
			# Icon
			LevelResource.TopicIcons.THREE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_g.tscn"),
			# Program Vars
			{
				"addend_1": 19,
				"addend_2": 9,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_4",
			# Title
			"5 - 4",
			# Icon
			LevelResource.TopicIcons.FOUR,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_g.tscn"),
			# Program Vars
			{
				"addend_1": 35,
				"addend_2": 30,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_5",
			# Title
			"5 - 5",
			# Icon
			LevelResource.TopicIcons.FIVE,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_g.tscn"),
			# Program Vars
			{
				"addend_1": 22,
				"addend_2": 29,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_6",
			# Title
			"5 - 6",
			# Icon
			LevelResource.TopicIcons.SIX,
			# Pimnet Data
			{
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_g.tscn"),
			# Program Vars
			{
				"addend_1": 37,
				"addend_2": 53,
			},
			# Program Plan
		),
		LevelResource.new(
			# ID
			"grid_counting_4_random",
			# Title
			"5 - Random",
			# Icon
			LevelResource.TopicIcons.UNKNOWN,
			# Pimnet Data
			{
				"level_type": LevelResource.LevelTypes.TRIAL_PRACTICE,
				"number_trials": 7,
				"time_limit": 60.0,
				"goal_type": LevelResource.GoalTypes.SOLUTION_MEMO_SLOTS,
				"pims": [
					preload("pims/grid_counting/grid_counting_pim.tscn"),
				],
				"enable_reversion": true,
				"enable_pim_tools": true,
				"enable_pim_objects": true,
			},
			# Program
			preload("level_programs/grid_counting_g.tscn"),
			# Program Vars
			{
				"min_addend_1": 0,
				"max_addend_1": 50,
				"min_addend_2": 0,
				"max_addend_2": 50,
			},
			# Program Plan
		),
	],


	# Subtopics
	[],


	# Layout
	preload("topic_layouts/grid_counting.tscn"),


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
			],
			LevelResource.TopicIcons.ONE,
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
			],
			LevelResource.TopicIcons.TWO,
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
			],
			LevelResource.TopicIcons.THREE,
		),
		TopicGroupResource.new(
			[
				"grid_counting_3_1",
				"grid_counting_3_2",
				"grid_counting_3_3",
				"grid_counting_3_4",
				"grid_counting_3_5",
				"grid_counting_3_6",
			],
			LevelResource.TopicIcons.FOUR,
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
			],
			LevelResource.TopicIcons.FIVE,
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


static var root_topic = TopicResource.new(
	# ID
	"basic_addition",
	# Title
	"Basic Addition",
	# Background
	TopicMap.Backgrounds.GREEN_TRIANGLES,
	# Levels
	[
	],
	# Subtopics
	[
		grid_counting_topic,
	],
	# Layout
	preload("topic_layouts/pack_root.tscn"),
	# Connections
	[
	],
	# Groups
	[
	]
)
