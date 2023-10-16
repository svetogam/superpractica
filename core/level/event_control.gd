##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Node

export(bool) var active := false
var menu: Control
var _level: Node


func _enter_tree() -> void:
	_level = get_parent()


func setup() -> void:
	if active:
		_setup_menu()


func _setup_menu() -> void:
	menu = _level.side_menu.add_panel(LevelSideMenu.LevelMenuPanels.EVENT_MENU)
	menu.enabler.connect_general(_level.verifier, "is_running", false)
	_level.connect("updated", menu.enabler, "update")
