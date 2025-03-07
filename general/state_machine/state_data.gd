# SPDX-FileCopyrightText: 2023 Super Practica contributors
# SPDX-FileCopyrightText: Copyright (c) 2007-2022 Juan Linietsky, Ariel Manzur.
# SPDX-FileCopyrightText: Copyright (c) 2014-2022 Godot Engine contributors.
#
# SPDX-License-Identifier: MIT

class_name StateData
extends RefCounted

# Virtual
func _get_data() -> Dictionary:
	return {}


func get_initial_state() -> String:
	return _get_data().initial


func get_transitions() -> Dictionary:
	return _get_data().transitions


func get_transitions_for_state(state: String) -> Dictionary:
	return _get_data().transitions[state]
