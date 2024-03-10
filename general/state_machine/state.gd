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

class_name State
extends Node

const NULL_STATE := "none"
var _state_machine: Node
var _target: Node
var _transition_triggers: Dictionary


func setup(p_state_machine: Node, p_target: Object, p_transition_triggers: Dictionary
) -> void:
	_state_machine = p_state_machine
	_target = p_target
	_transition_triggers = p_transition_triggers
	_on_setup()


# Virtual
func _on_setup() -> void:
	pass


# Virtual
func _enter(_last_state: String) -> void:
	pass


# Virtual
func _exit(_next_state: String) -> void:
	pass


func _change_state(next_state: String) -> void:
	_state_machine.change_state(next_state)


func _transition(trigger: String) -> void:
	assert(_transition_triggers.has(trigger))
	if _transition_triggers[trigger] == NULL_STATE:
		_state_machine.deactivate()
	else:
		_change_state(_transition_triggers[trigger])


func _is_current() -> bool:
	return _state_machine.get_current_state() == name
