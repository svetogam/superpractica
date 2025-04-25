# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name LevelResource
extends Resource

enum GoalTypes {
	NONE = 0,
	HINTED_MEMO_SLOT,
	SOLUTION_MEMO_SLOTS,
	CONSTRUCT_CONDITIONS,
}
enum LevelIcons {
	ZERO = 0,
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE,
	SIX,
	SEVEN,
	EIGHT,
	NINE,
	UNKNOWN,
}

@export var id: String
@export var title: String
@export var icon: LevelIcons
@export var pimnet_setup: PimnetSetupResource
@export var goal_type: GoalTypes
@export var program: PackedScene
@export var program_vars: LevelProgramVars
@export var program_plan: PlanResource
var topic: TopicResource
var extended_title: String:
	get:
		return topic.title + " > " + title


func _init(
	p_id := "",
	p_title := "",
	p_icon := LevelIcons.UNKNOWN,
	p_pimnet_setup: PimnetSetupResource = null,
	p_goal_type := GoalTypes.NONE,
	p_program: PackedScene = null,
	p_program_vars: LevelProgramVars = null,
	p_program_plan: PlanResource = null,
) -> void:
	id = p_id
	title = p_title
	icon = p_icon
	pimnet_setup = p_pimnet_setup
	goal_type = p_goal_type
	program = p_program
	program_vars = p_program_vars
	program_plan = p_program_plan


func get_next_suggested_level() -> LevelResource:
	return topic.get_suggested_level_after(id)


func has_next_suggested_level() -> bool:
	return get_next_suggested_level() != null
