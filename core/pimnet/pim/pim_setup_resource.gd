##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name PimSetupResource
extends Resource

export(Vector2) var field_zoom := Vector2(1, 1)
export(bool) var have_menu := true
export(bool) var have_tool_menu := false
export(bool) var include_all_tools := true
export(bool) var have_spawn_panel := false
export(bool) var include_all_spawners := true
export(bool) var have_memo_output_panel := false


#Virtual
func get_field_scene() -> PackedScene:
	return null


#Virtual
func _get_initial_tool_id() -> int:
	return GameGlobals.NO_TOOL


#Virtual
func _get_tool_id_to_name_map() -> Dictionary:
	return {}


#Virtual
func _get_included_tools() -> Array:
	return []


#Virtual
func _get_disabled_tools() -> Array:
	return []


#Virtual
func _get_spawners_to_objects_map() -> Dictionary:
	return {}


#Virtual
func _get_included_spawners() -> Array:
	return []


func get_initial_tool() -> String:
	var tool_id = _get_initial_tool_id()
	if tool_id != GameGlobals.NO_TOOL:
		var tool_names_map = _get_tool_id_to_name_map()
		return tool_names_map[tool_id]
	else:
		return ""


func get_menu_setup_data() -> Dictionary:
	var menu_setup_data = {}
	menu_setup_data.panels = _get_menu_panels()

	if have_tool_menu:
		menu_setup_data[PimSideMenu.PimMenuPanels.TOOL_MENU] = {
			"included": _get_included_tool_names(),
			"disabled": _get_disabled_tool_names(),
		}

	if have_spawn_panel:
		menu_setup_data[PimSideMenu.PimMenuPanels.OBJECT_GENERATOR] = {
			"included": _get_included_spawner_object_types(),
		}

	return menu_setup_data


func _get_menu_panels() -> Array:
	var panels = []
	if have_menu:
		if have_tool_menu:
			panels.append(PimSideMenu.PimMenuPanels.TOOL_MENU)
		if have_spawn_panel:
			panels.append(PimSideMenu.PimMenuPanels.OBJECT_GENERATOR)
		if have_memo_output_panel:
			panels.append(PimSideMenu.PimMenuPanels.MEMO_OUTPUT)
	return panels


func _get_included_tool_names() -> Array:
	var id_list
	if include_all_tools:
		return _get_tool_id_to_name_map().values()
	else:
		id_list = _get_included_tools()
		return _get_name_list_from_tool_id_list(id_list)


func _get_disabled_tool_names() -> Array:
	var id_list = _get_disabled_tools()
	return _get_name_list_from_tool_id_list(id_list)


func _get_name_list_from_tool_id_list(id_list: Array) -> Array:
	var name_list = []
	var tool_names_map = _get_tool_id_to_name_map()
	for tool_id in tool_names_map:
		if id_list.has(tool_id):
			var tool_name = tool_names_map[tool_id]
			name_list.append(tool_name)
	return name_list


func _get_included_spawner_object_types() -> Array:
	var spawner_to_object_map = _get_spawners_to_objects_map()
	if include_all_spawners:
		var all_spawner_types = spawner_to_object_map.keys()
		return _get_object_types_from_spawner_types(all_spawner_types)
	else:
		var included_spawner_types = _get_included_spawners()
		return _get_object_types_from_spawner_types(included_spawner_types)


func _get_object_types_from_spawner_types(spawner_types: Array) -> Array:
	var object_types = []
	var spawner_to_object_map = _get_spawners_to_objects_map()
	for spawner_type in spawner_types:
		var object_type = spawner_to_object_map[spawner_type]
		object_types.append(object_type)
	return object_types
