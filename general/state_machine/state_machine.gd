# SPDX-FileCopyrightText: 2023 Super Practica contributors
# SPDX-FileCopyrightText: Copyright (c) 2007-2022 Juan Linietsky, Ariel Manzur.
# SPDX-FileCopyrightText: Copyright (c) 2014-2022 Godot Engine contributors.
#
# SPDX-License-Identifier: MIT

class_name StateMachine
extends Node

@export var SetupData: GDScript
## Priority for target is:
## [br]
## 1. Inspector
## [br]
## 2. Parent
@export var _target: Node
## Priority for initial state is:
## [br]
## 1. Method parameter
## [br]
## 2. Setup Data
## [br]
## 3. Inspector
@export var _initial_state: State
## [b]Warning[/b]: If turned on, it may call [code]State._enter()[/code] before
## the target's [code]_ready()[/code] function is called.
## Set to off and call [code]activate()[/code] manually to ensure correct
## order in all cases.
@export var _auto_activate := true
## This calls [code]deactivate()[/code] when exiting the tree.
## [br][br]
## [b]Warning[/b]: If turned on, it may set up a race condition when the state machine
## is exiting the tree together with other nodes. To solve this, call
## [code]deactivate()[/code] manually before removing the whole scene that the
## state machine is a part of.
@export var _auto_deactivate := false
var _current_state: State
var _setup_data: StateData


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
	if is_active() and _auto_deactivate:
		deactivate()


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
