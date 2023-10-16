##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
# Copyright (c) 2007-2022 Juan Linietsky, Ariel Manzur.                      #
# Copyright (c) 2014-2022 Godot Engine contributors.                         #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name StateData
extends Reference

#Virtual
func _get_data() -> Dictionary:
	return {}


func get_initial_state() -> String:
	return _get_data().initial


func get_transitions() -> Dictionary:
	return _get_data().transitions


func get_transitions_for_state(state: String) -> Dictionary:
	return _get_data().transitions[state]
