#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name PimSideMenu
extends VPanelMenu

enum PimMenuPanels {
	TOOL_MENU = 0,
	OBJECT_GENERATOR = 1,
	MEMO_OUTPUT = 2,
}

const PANEL_MAP := {
	PimMenuPanels.TOOL_MENU: preload("panels/tool_menu.tscn"),
	PimMenuPanels.MEMO_OUTPUT: preload("panels/memo_output.tscn"),
	PimMenuPanels.OBJECT_GENERATOR: preload("panels/spawn_panel/spawn_panel.tscn"),
}


func _get_panel_map() -> Dictionary:
	return PANEL_MAP
