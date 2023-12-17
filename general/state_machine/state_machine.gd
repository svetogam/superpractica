#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
# Copyright (c) 2007-2022 Juan Linietsky, Ariel Manzur.                      #
# Copyright (c) 2014-2022 Godot Engine contributors.                         #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

class_name StateMachine
extends Node

@export var SetupData: GDScript
@export var _target: Node
@export var _initial_state: State
@export var _auto_activate := true
var _current_state: State
var _setup_data: StateData


func _ready() -> void:
	if SetupData != null:
		_setup_data = SetupData.new()

	if _auto_activate:
		activate()


func activate(initial_state_name := "") -> void:
	assert(not is_active())
	_setup()
	_current_state = _get_initial_state(initial_state_name)
	_current_state._enter(State.NULL_STATE)


func _setup() -> void:
	_set_target()
	_setup_states()


# Priority for target is: 1-inspector, 2-parent
func _set_target() -> void:
	if _target == null:
		_target = get_parent()
	assert(_target != null)


# Priority for initial state is:
# 1-activation parameter, 2-setup_data, 3-inspector
func _get_initial_state(initial_state_name: String) -> State:
	if initial_state_name != "":
		return get_node(initial_state_name) as State
	elif _setup_data != null:
		return get_node(_setup_data.get_initial_state()) as State
	else:
		assert(_initial_state != null)
		return _initial_state


func _setup_states() -> void:
	for state in _get_states():
		assert(state is State)
		var transitions := {}
		if _setup_data != null:
			transitions = _setup_data.get_transitions_for_state(state.name)
		state.setup(self, _target, transitions)


func _get_states() -> Array:
	return get_children()


func _exit_tree() -> void:
	if is_active():
		deactivate()


func deactivate() -> void:
	assert(is_active())
	_current_state._exit(State.NULL_STATE)
	_current_state = null
	_target = null


func is_active() -> bool:
	return _current_state != null


func change_state(state_name: String) -> void:
	var last_state_name := _get_current_state_name()
	var new_state := _get_state_by_name(state_name)

	_current_state._exit(state_name)
	_current_state = new_state
	_current_state._enter(last_state_name)


func _get_current_state_name() -> String:
	if is_active():
		return _current_state.name
	return State.NULL_STATE


func _get_state_by_name(state_name: String) -> State:
	return get_node(state_name) as State


func get_current_state() -> State:
	return _current_state
