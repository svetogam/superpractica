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

@export var id: String
@export var title: String
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
	p_pimnet_setup: PimnetSetupResource = null,
	p_goal_type := GoalTypes.NONE,
	p_program: PackedScene = null,
	p_program_vars: LevelProgramVars = null,
	p_program_plan: PlanResource = null,
) -> void:
	id = p_id
	title = p_title
	pimnet_setup = p_pimnet_setup
	goal_type = p_goal_type
	program = p_program
	program_vars = p_program_vars
	program_plan = p_program_plan
