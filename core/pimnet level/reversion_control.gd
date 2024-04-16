#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name ReversionControl
extends Node

signal reset_completed

var _level: Level
var _menu: Control
var _mem_state_control := MemStateControl.new()
var _reset_function := _default_reset


func _enter_tree():
	_level = get_parent()


#Call this after adding all pims
func setup() -> void:
	_menu = _level.pimnet.overlay.reversion_menu
	var pim_list := _level.pimnet.get_pim_list()
	_mem_state_control.start(pim_list)
	_setup_menu()

	_level.actions_completed.connect(_on_actions_completed)


func _on_actions_completed() -> void:
	_mem_state_control.save_combined_state(false)


func clear_history() -> void:
	_mem_state_control.restart()


#====================================================================
# Menu
#====================================================================

func _setup_menu() -> void:
	_menu.undo_pressed.connect(_mem_state_control.undo)
	_menu.redo_pressed.connect(_mem_state_control.redo)
	_menu.reset_pressed.connect(reset)

	_menu.enabler.connect_button("undo", _mem_state_control.is_undo_possible)
	_menu.enabler.connect_button("redo", _mem_state_control.is_redo_possible)
	_menu.enabler.connect_button("reset", _is_reset_possible)
	_menu.enabler.connect_general(_level.verifier.is_running, false)

	_level.updated.connect(_menu.enabler.update)
	_mem_state_control.state_saved.connect(_menu.enabler.update)
	_mem_state_control.state_loaded.connect(_menu.enabler.update)

	_menu.enabler.update()


func _is_reset_possible() -> bool:
	return not _reset_function.is_null()


#====================================================================
# Reset
#====================================================================

func reset() -> void:
	if not _reset_function.is_null():
		_reset_function.call()

	reset_completed.emit()


func set_no_reset() -> void:
	_reset_function = Callable()
	_menu.enabler.update()


func set_default_reset() -> void:
	_reset_function = _default_reset
	_menu.enabler.update()


func _default_reset() -> void:
	for pim in _level.pimnet.get_pim_list():
		pim.reset()


func set_custom_reset(callable: Callable) -> void:
	_reset_function = callable
	_menu.enabler.update()
