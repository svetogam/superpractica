#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name CountingBoardPim
extends Pim

enum Tools {
	NONE = GameGlobals.NO_TOOL,
	NUMBER_CIRCLER,
	SQUARE_MARKER,
	COUNTER_CREATOR,
	COUNTER_DELETER,
	COUNTER_DRAGGER,
	MEMO_GRABBER,
}
enum Spawners {
	COUNTER,
}

const TOOL_ID_TO_NAME_MAP := {
	Tools.NUMBER_CIRCLER: "NumberCircler",
	Tools.SQUARE_MARKER: "SquareMarker",
	Tools.COUNTER_CREATOR: "CounterCreator",
	Tools.COUNTER_DELETER: "CounterDeleter",
	Tools.COUNTER_DRAGGER: "CounterDragger",
	Tools.MEMO_GRABBER: "MemoGrabber",
}
const SPAWNER_SCENES := {
	CountingBoard.Objects.COUNTER: preload("spawners/counter_spawner.tscn"),
}
const SPAWNERS_TO_OBJECTS := {
	Spawners.COUNTER: CountingBoard.Objects.COUNTER,
}


@export var field_scene := preload("res://content/basic_addition/"
		+ "fields/counting_board/counting_board_field.tscn")
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
