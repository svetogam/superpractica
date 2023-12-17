#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name BubbleSumPim
extends Pim

enum Tools {
	NONE = GameGlobals.NO_TOOL,
	MOVER,
	UNIT_CREATOR,
	BUBBLE_CREATOR,
	UNIT_DELETER,
	BUBBLE_POPPER,
	BUBBLE_DELETER,
	BUBBLE_EDITOR,
	BUBBLE_RESIZER,
	UNIT_SELECTOR,
	BUBBLE_SELECTOR,
	UNIT_COUNTER,
}
enum Spawners {
	UNIT,
	BUBBLE,
}

const TOOL_ID_TO_NAME_MAP := {
	Tools.MOVER: "Mover",
	Tools.UNIT_CREATOR: "UnitCreator",
	Tools.BUBBLE_CREATOR: "BubbleCreator",
	Tools.UNIT_DELETER: "UnitDeleter",
	Tools.BUBBLE_POPPER: "BubblePopper",
	Tools.BUBBLE_DELETER: "BubbleDeleter",
	Tools.BUBBLE_EDITOR: "BubbleEditor",
	Tools.BUBBLE_RESIZER: "BubbleResizer",
	Tools.UNIT_SELECTOR: "UnitSelector",
	Tools.BUBBLE_SELECTOR: "BubbleSelector",
	Tools.UNIT_COUNTER: "UnitCounter",
}
const SPAWNER_SCENES := {
	BubbleSum.Objects.UNIT: preload("spawners/unit_spawner.tscn"),
	BubbleSum.Objects.BUBBLE: preload("spawners/bubble_spawner.tscn"),
}
const SPAWNERS_TO_OBJECTS := {
	Spawners.UNIT: BubbleSum.Objects.UNIT,
	Spawners.BUBBLE: BubbleSum.Objects.BUBBLE,
}

@export var field_scene := preload(
		"res://content/debug/fields/bubble_sum/bubble_sum_field.tscn")
@export var initial_tool: Tools
@export var included_tools: Array[Tools]
@export var disabled_tools: Array[Tools]
@export var included_spawners: Array[Spawners]


func get_spawner_scenes() -> Dictionary:
	return SPAWNER_SCENES


func _get_field_scene() -> PackedScene:
	return field_scene


func _get_tool_id_to_name_map() -> Dictionary:
	return TOOL_ID_TO_NAME_MAP


func _get_initial_tool_id() -> int:
	return initial_tool


func _get_included_tools() -> Array:
	return included_tools


func _get_disabled_tools() -> Array:
	return disabled_tools


func _get_spawners_to_objects_map() -> Dictionary:
	return SPAWNERS_TO_OBJECTS


func _get_included_spawners() -> Array:
	return included_spawners
