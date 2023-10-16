##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name ModeGroup
extends Node

signal mode_started(mode_name)
signal mode_stopped(mode_name)

export(NodePath) var _target_path: NodePath
var _target: Node


func _enter_tree() -> void:
	_set_target()


#Priority for target is: 1-inspector field, 2-parent
func _set_target() -> void:
	if not _target_path.is_empty():
		_target = get_node(_target_path)
	else:
		_target = get_parent()
	assert(_target != null)


func _ready() -> void:
	for mode in get_modes():
		mode.connect("started", self, "emit_signal", ["mode_started", mode.name])
		mode.connect("stopped", self, "emit_signal", ["mode_stopped", mode.name])

	for mode in get_active_modes():
		emit_signal("mode_started", mode.name)


func activate(mode_name: String) -> void:
	var mode = get_mode(mode_name)
	if not mode.is_running():
		mode.run()


func activate_all() -> void:
	for mode in get_modes():
		if not mode.is_running():
			mode.run()


func activate_only(mode_name: String) -> void:
	for mode in get_active_modes():
		if mode.name != mode_name:
			mode.stop()

	activate(mode_name)


func deactivate(mode_name: String) -> void:
	var mode = get_mode(mode_name)
	mode.stop()


func deactivate_all() -> void:
	for mode in get_active_modes():
		mode.stop()


#Activate all modes in the list and deactivate all others
func set_by_list(target_list: Array) -> void:
	var mode_names = get_mode_names()
	for mode_name in target_list:
		assert(mode_names.has(mode_name))

	for mode_name in mode_names:
		if target_list.has(mode_name):
			activate(mode_name)
		else:
			deactivate(mode_name)


#Pass a name-to-bool dict to activate and deactivate accordingly
func set_by_dict(target_dict: Dictionary) -> void:
	var mode_names = get_mode_names()
	for mode_name in target_dict:
		assert(mode_names.has(mode_name))

	for mode_name in mode_names:
		if target_dict.has(mode_name):
			if target_dict[mode_name]:
				activate(mode_name)
			else:
				deactivate(mode_name)


func get_mode(mode_name: String) -> Node:
	for mode in get_modes():
		if mode.name == mode_name:
			return mode
	return null


func get_only_active_mode() -> Node:
	var active_modes = get_active_modes()
	if active_modes.size() == 1:
		return active_modes[0]
	return null


func get_only_active_mode_name() -> String:
	var active_mode = get_only_active_mode()
	if active_mode != null:
		return active_mode.name
	return ""


func get_mode_names() -> Array:
	var mode_names = []
	for mode in get_modes():
		mode_names.append(mode.name)
	return mode_names


func get_active_mode_names() -> Array:
	var active_mode_names = []
	for mode in get_active_modes():
		active_mode_names.append(mode.name)
	return active_mode_names


func is_active(mode_name: String) -> bool:
	return get_mode(mode_name).is_running()


func is_any_active() -> bool:
	return not get_active_modes().empty()


func get_modes() -> Array:
	return get_children()


func get_active_modes() -> Array:
	var active_modes = []
	for mode in get_modes():
		if mode.is_running():
			active_modes.append(mode)
	return active_modes
