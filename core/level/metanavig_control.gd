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

@export var active := false
var _level: Level
var _menu: Control
var _mem_state_control := MemStateControl.new()
var _reset_callback: Callable


func _enter_tree():
	_level = get_parent()


#Call this after adding all pims
func setup() -> void:
	var pim_list = _level.pimnet.get_pim_list()
	_mem_state_control.start(pim_list)
	_setup_menu()
	set_default_reset()

	_level.actions_completed.connect(_on_actions_completed)


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

	_menu.undo_pressed.connect(_mem_state_control.undo)
	_menu.redo_pressed.connect(_mem_state_control.redo)
	_menu.reset_pressed.connect(reset)

	_menu.enabler.connect_button("undo", _mem_state_control, "is_undo_possible")
	_menu.enabler.connect_button("redo", _mem_state_control, "is_redo_possible")
	_menu.enabler.connect_button("reset", self, "_is_reset_possible")
	_menu.enabler.connect_general(_level.verifier, "is_running", false)

	_level.updated.connect(_menu.enabler.update)
	_mem_state_control.state_saved.connect(_menu.enabler.update)
	_mem_state_control.state_loaded.connect(_menu.enabler.update)

	_menu.enabler.update()


func _is_reset_possible() -> bool:
	return not _reset_callback.is_null()


#####################################################################
# Reset
#####################################################################

func reset() -> void:
	if not _reset_callback.is_null():
		_reset_callback.call()

	reset_completed.emit()


func set_no_reset() -> void:
	_reset_callback = Callable()
	_menu.enabler.update()


func set_default_reset() -> void:
	_reset_callback = Callable(self, "_default_reset")
	_menu.enabler.update()


func _default_reset() -> void:
	for pim in _level.pimnet.get_pim_list():
		pim.reset()


func set_custom_reset(callback_object: Object, callback_method: String) -> void:
	_reset_callback = Callable(callback_object, callback_method)
	_menu.enabler.update()
