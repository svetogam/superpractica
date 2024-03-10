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
## Warning: If turned on, it may call State._enter() before
## the target's _ready() function is called.
## Set to off and call activate() manually to ensure correct
## order in all cases.
@export var _auto_activate := true
var _current_state: State
var _setup_data: StateData


## Priority for target is:
## 1. Inspector, 2. Parent
func _ready() -> void:
	# Set target
	if _target == null:
		_target = get_parent()
	assert(_target != null)

	if SetupData != null:
		_setup_data = SetupData.new()

	# Set up states
	for state in get_children():
		assert(state is State)
		var transitions := {}
		if _setup_data != null:
			transitions = _setup_data.get_transitions_for_state(state.name)
		_disable_state(state)
		state.setup(self, _target, transitions)

	if _auto_activate:
		activate()


func _exit_tree() -> void:
	if is_active():
		deactivate()


## Priority for initial state is:
## 1. Method parameter, 2. Setup Data, 3. Inspector
func activate(initial_state_name := "") -> void:
	assert(not is_active())

	# Get initial state
	if initial_state_name != "":
		_current_state = get_node(initial_state_name) as State
	elif _setup_data != null:
		_current_state = get_node(_setup_data.get_initial_state()) as State
	else:
		assert(_initial_state != null)
		_current_state = _initial_state

	# Enter initial state
	_enable_state(_current_state)
	_current_state._enter(State.NULL_STATE)


func deactivate() -> void:
	assert(is_active())
	_current_state._exit(State.NULL_STATE)
	_current_state = null


func change_state(state_name: String) -> void:
	var last_state_name := get_current_state()
	var new_state := _get_state_by_name(state_name)

	_disable_state(_current_state)
	_current_state._exit(state_name)
	_current_state = new_state
	_enable_state(_current_state)
	_current_state._enter(last_state_name)


func is_active() -> bool:
	return _current_state != null


func get_current_state() -> String:
	if is_active():
		return _current_state.name
	return State.NULL_STATE


func _disable_state(state: State) -> void:
	state.process_mode = Node.PROCESS_MODE_DISABLED


func _enable_state(state: State) -> void:
	state.process_mode = Node.PROCESS_MODE_INHERIT


func _get_state_by_name(state_name: String) -> State:
	return get_node(state_name) as State
