##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name MetanavigControl
extends Node

signal reset_completed

export(bool) var active := false
var _level: Node
var _menu: Control
var _mem_state_control := MemStateControl.new()
var _reset_callback: FuncRef


func _enter_tree():
	_level = get_parent()


#Call this after adding all pims
func setup() -> void:
	var pim_list = _level.pimnet.get_pim_list()
	_mem_state_control.start(pim_list)
	_setup_menu()
	set_default_reset()

	_level.connect("actions_completed", self, "_on_actions_completed")


func _on_actions_completed() -> void:
	if active:
		_mem_state_control.save_combined_state(false)


func clear_history() -> void:
	if active:
		_mem_state_control.restart()


#####################################################################
# Menu
#####################################################################

func _setup_menu() -> void:
	_menu = _level.side_menu.add_panel(_level.side_menu.LevelMenuPanels.METANAVIG_MENU)

	_menu.connect("undo_pressed", _mem_state_control, "undo")
	_menu.connect("redo_pressed", _mem_state_control, "redo")
	_menu.connect("reset_pressed", self, "reset")

	_menu.enabler.connect_button("undo", _mem_state_control, "is_undo_possible")
	_menu.enabler.connect_button("redo", _mem_state_control, "is_redo_possible")
	_menu.enabler.connect_button("reset", self, "_is_reset_possible")
	_menu.enabler.connect_general(_level.verifier, "is_running", false)

	_level.connect("updated", _menu.enabler, "update")
	_mem_state_control.connect("state_saved", _menu.enabler, "update")
	_mem_state_control.connect("state_loaded", _menu.enabler, "update")

	_menu.enabler.update()


func _is_reset_possible() -> bool:
	return _reset_callback != null


#####################################################################
# Reset
#####################################################################

func reset() -> void:
	if _reset_callback != null:
		_reset_callback.call_func()

	emit_signal("reset_completed")


func set_no_reset() -> void:
	_reset_callback = null
	_menu.enabler.update()


func set_default_reset() -> void:
	_reset_callback = funcref(self, "_default_reset")
	_menu.enabler.update()


func _default_reset() -> void:
	for pim in _level.pimnet.get_pim_list():
		pim.reset()


func set_custom_reset(callback_object: Object, callback_method: String) -> void:
	_reset_callback = funcref(callback_object, callback_method)
	_menu.enabler.update()
