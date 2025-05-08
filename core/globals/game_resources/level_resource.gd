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
enum TopicIcons {
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

const Icon0 := preload("uid://b142mgnn28pxw")
const Icon1 := preload("uid://b7l7y1oekekox")
const Icon2 := preload("uid://tdg04xul7v88")
const Icon3 := preload("uid://cmi7bkby3jvbe")
const Icon4 := preload("uid://donuv2btt7rdm")
const Icon5 := preload("uid://fcfbijuaxc6r")
const Icon6 := preload("uid://cdk28y17eiayv")
const Icon7 := preload("uid://hod4gc5iwoal")
const Icon8 := preload("uid://cwde7pv5bayt8")
const Icon9 := preload("uid://3uvpobw6wit5")
const IconQuestionMark := preload("uid://clk6yic0okqp6")

@export var id: String
@export var title: String
@export var icon: TopicIcons
@export var pimnet_setup: PimnetSetupResource
@export var goal_type: GoalTypes
@export var program: PackedScene
@export var program_vars: LevelProgramVars
@export var program_plan: PlanResource
var topic: TopicResource
var extended_title: String:
	get:
		return topic.title + " > " + title


static func get_icon_texture_for(p_icon: TopicIcons) -> Texture2D:
	match p_icon:
		LevelResource.TopicIcons.ZERO:
			return Icon0
		LevelResource.TopicIcons.ONE:
			return Icon1
		LevelResource.TopicIcons.TWO:
			return Icon2
		LevelResource.TopicIcons.THREE:
			return Icon3
		LevelResource.TopicIcons.FOUR:
			return Icon4
		LevelResource.TopicIcons.FIVE:
			return Icon5
		LevelResource.TopicIcons.SIX:
			return Icon6
		LevelResource.TopicIcons.SEVEN:
			return Icon7
		LevelResource.TopicIcons.EIGHT:
			return Icon8
		LevelResource.TopicIcons.NINE:
			return Icon9
		LevelResource.TopicIcons.UNKNOWN:
			return IconQuestionMark
		_:
			assert(false)
			return null


func _init(
	p_id := "",
	p_title := "",
	p_icon := TopicIcons.UNKNOWN,
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


func get_icon_texture() -> Texture2D:
	return get_icon_texture_for(icon)
