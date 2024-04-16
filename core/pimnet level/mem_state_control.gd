#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name MemStateControl
extends RefCounted

signal state_saved
signal state_loaded

const MAX_HISTORY: int = 20
var _pim_list: Array = []
var _stack_tracker := StackTracker.new(MAX_HISTORY, true)


#Call this after adding all pims, before any save
func start(p_pim_list: Array) -> void:
	_pim_list = p_pim_list
	_save_initial_state()


func restart() -> void:
	_stack_tracker.clear()
	_save_initial_state()


func _save_initial_state() -> void:
	save_combined_state(true)


func save_combined_state(save_if_no_change := true) -> void:
	var combined_state := _get_combined_state()

	#Abort if no change
	if not save_if_no_change:
		var last_state = _stack_tracker.get_current_item()
		if _are_combined_states_equal(combined_state, last_state):
			return

	_stack_tracker.push_item(combined_state)

	state_saved.emit()


func _get_combined_state() -> Dictionary:
	var combined_state := {}
	for pim in _pim_list:
		if pim is FieldPim:
			var id = pim.get_instance_id()
			combined_state[id] = pim.field.build_mem_state()
			assert(combined_state[id] != null)
	return combined_state


func _are_combined_states_equal(comb_state_1: Dictionary, comb_state_2: Dictionary
) -> bool:
	var num_equal: int = 0
	for pim in _pim_list:
		var id = pim.get_instance_id()
		if comb_state_1[id].is_equal_to(comb_state_2[id]):
			num_equal += 1
	return num_equal == len(_pim_list)


func is_undo_possible() -> bool:
	return not _stack_tracker.is_position_at_back()


func is_redo_possible() -> bool:
	return not _stack_tracker.is_position_at_front()


func undo() -> void:
	if is_undo_possible():
		_stack_tracker.move_position_back()
		load_state()


func redo() -> void:
	if is_redo_possible():
		_stack_tracker.move_position_forward()
		load_state()


func load_state(position_to_load: int = -1) -> void:
	if position_to_load != -1:
		_stack_tracker.set_position(position_to_load)

	var combined_load := _get_stored_state()
	for pim in _pim_list:
		var id =  pim.get_instance_id()
		pim.field.load_mem_state(combined_load[id])

	state_loaded.emit()


func _get_stored_state() -> Dictionary:
	return _stack_tracker.get_current_item()
