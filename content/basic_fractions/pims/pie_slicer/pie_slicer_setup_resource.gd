##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name PieSlicerSetupResource
extends PimSetupResource

enum Tools {
	NONE = GameGlobals.NO_TOOL,
	SLICE_ADDER,
	SLICE_REMOVER,
	REGION_SELECTOR,
	REGION_COUNTER,
}
const TOOL_ID_TO_NAME_MAP := {
	Tools.SLICE_ADDER: "SliceAdder",
	Tools.SLICE_REMOVER: "SliceRemover",
	Tools.REGION_SELECTOR: "RegionSelector",
	Tools.REGION_COUNTER: "RegionCounter",
}

enum Spawners {
}
const SPAWNERS_TO_OBJECTS := {
}

export(PackedScene) var field_scene :=\
		preload("res://content/basic_fractions/fields/pie_slicer/pie_slicer_field.tscn")
export(Tools) var initial_tool: int
export(Array, Tools) var included_tools: Array
export(Array, Tools) var disabled_tools: Array
export(Array, Spawners) var included_spawners: Array


#Virtual
func get_field_scene() -> PackedScene:
	return field_scene


#Virtual
func _get_tool_id_to_name_map() -> Dictionary:
	return TOOL_ID_TO_NAME_MAP


#Virtual
func _get_initial_tool_id() -> int:
	return initial_tool


#Virtual
func _get_included_tools() -> Array:
	return included_tools


#Virtual
func _get_disabled_tools() -> Array:
	return disabled_tools


#Virtual
func _get_spawners_to_objects_map() -> Dictionary:
	return SPAWNERS_TO_OBJECTS


#Virtual
func _get_included_spawners() -> Array:
	return included_spawners
