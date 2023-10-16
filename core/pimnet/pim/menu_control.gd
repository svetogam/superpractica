##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends WindowContent

const TOOL_MENU := PimSideMenu.PimMenuPanels.TOOL_MENU
const SPAWN_PANEL := PimSideMenu.PimMenuPanels.OBJECT_GENERATOR
const MEMO_OUTPUT := PimSideMenu.PimMenuPanels.MEMO_OUTPUT

var tool_menu: WindowContent setget _do_not_set
var spawn_panel: WindowContent setget _do_not_set
var memo_output_slot: WindowContent setget _do_not_set
var _pim: WindowContent
onready var _side_menu := $"%SideMenu"


func _ready() -> void:
	hide_menu()


func setup(p_pim: WindowContent) -> void:
	_pim = p_pim


func build(setup_data: Dictionary) -> void:
	var panels = setup_data.panels
	if not panels.empty():
		show()

	if panels.has(TOOL_MENU):
		add_tool_menu(setup_data[TOOL_MENU].included)
		tool_menu.disable_tools(setup_data[TOOL_MENU].disabled)
	if panels.has(SPAWN_PANEL):
		add_spawn_panel(setup_data[SPAWN_PANEL].included)
	if panels.has(MEMO_OUTPUT):
		add_memo_output_panel()


func show_menu() -> void:
	show()


func hide_menu() -> void:
	hide()


func remove_panel(panel: int) -> void:
	if not _side_menu.has_panel(panel):
		Game.debug.warn("Cannot remove non-existing panel.")
		return

	_side_menu.remove_panel(panel)


func add_tool_menu(included:=[]) -> WindowContent:
	if _side_menu.has_panel(TOOL_MENU):
		Game.debug.warn("Tool menu already exists.")
		return null

	tool_menu = _side_menu.add_panel(TOOL_MENU)
	tool_menu.connect("tree_exited", self, "_on_tool_menu_removed")

	var tool_map = _pim.field.get_tool_mode_to_text_map()
	tool_menu.setup(tool_map, included)

	_connect_tool_menu_to_field()

	return tool_menu


func _connect_tool_menu_to_field() -> void:
	_set_initial_tool_in_menu()

	tool_menu.connect("tool_selected", _pim.field, "set_tool")
	_pim.field.connect("tool_changed", self, "_update_tool_menu")


func _set_initial_tool_in_menu() -> void:
	var current_tool = _pim.field.get_tool()
	if current_tool != "":
		tool_menu.set_tool(current_tool)


func _update_tool_menu(new_tool: String) -> void:
	if tool_menu != null:
		tool_menu.set_tool(new_tool)


func _on_tool_menu_removed() -> void:
	tool_menu = null
	_pim.field.disconnect("tool_changed", self, "_update_tool_menu")


func add_spawn_panel(included:=[]) -> WindowContent:
	if _side_menu.has_panel(SPAWN_PANEL):
		Game.debug.warn("Spawn panel already exists.")
		return null

	spawn_panel = _side_menu.add_panel(SPAWN_PANEL)
	spawn_panel.setup(_pim.spawner_factory, included)
	return spawn_panel


func add_memo_output_panel() -> WindowContent:
	if _side_menu.has_panel(MEMO_OUTPUT):
		Game.debug.warn("Memo output panel already exists.")
		return null

	var memo_output_panel = _side_menu.add_panel(MEMO_OUTPUT)
	memo_output_panel.connect("tree_exited", self, "_on_memo_output_panel_removed")

	memo_output_slot = memo_output_panel.memo_slot
	_pim.get_program("GiveOutputMemo").run()

	return memo_output_panel


func _on_memo_output_panel_removed() -> void:
	_pim.get_program("GiveOutputMemo").stop()
	memo_output_slot = null


func _do_not_set(_p) -> void:
	assert(false)
