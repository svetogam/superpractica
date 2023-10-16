##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name LevelSideMenu
extends VPanelMenu

enum LevelMenuPanels {
	LEVEL_CONTROL_MENU,
	METANAVIG_MENU,
	EVENT_MENU,
}

const PANEL_MAP := {
	LevelMenuPanels.LEVEL_CONTROL_MENU:
		preload("level_control_menu.tscn"),
	LevelMenuPanels.METANAVIG_MENU:
		preload("metanavig_menu.tscn"),
	LevelMenuPanels.EVENT_MENU:
		preload("event_menu.tscn"),
}


func _get_panel_map() -> Dictionary:
	return PANEL_MAP
