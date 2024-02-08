#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

extends Node

const GENERAL_CALLBACK_ID := "_"
var _button_map: Dictionary
var _disabled := false
var _conditions_map := CallableMap.new()
var _anti_conditions_map := CallableMap.new()


func add_button(button_id: String, button: BaseButton) -> void:
	_button_map[button_id] = button
	update()


func disable_all(p_disabled := true) -> void:
	_disabled = p_disabled
	update()


func connect_button(button_id: String, callable: Callable, sought := true) -> void:
	assert(_button_map.has(button_id))
	if sought == true:
		_conditions_map.add(button_id, callable)
	else:
		_anti_conditions_map.add(button_id, callable)
	update()


func disconnect_button(button_id: String, callable: Callable) -> void:
	assert(_button_map.has(button_id))
	if _conditions_map.has(button_id):
		_conditions_map.remove(button_id, callable)
	if _anti_conditions_map.has(button_id):
		_anti_conditions_map.remove(button_id, callable)
	update()


func connect_general(callable: Callable, sought := true) -> void:
	if sought == true:
		_conditions_map.add(GENERAL_CALLBACK_ID, callable)
	else:
		_anti_conditions_map.add(GENERAL_CALLBACK_ID, callable)
	update()


func disconnect_general(callable: Callable) -> void:
	if _conditions_map.has(GENERAL_CALLBACK_ID):
		_conditions_map.remove(GENERAL_CALLBACK_ID, callable)
	if _anti_conditions_map.has(GENERAL_CALLBACK_ID):
		_anti_conditions_map.remove(GENERAL_CALLBACK_ID, callable)
	update()


func disconnect_all() -> void:
	_conditions_map.clear()
	_anti_conditions_map.clear()


func update() -> void:
	for button_id in _button_map.keys():
		var button = _button_map[button_id]
		if _should_disable_button(button_id):
			button.disabled = true
		else:
			button.disabled = false


func _should_disable_button(button_id: String) -> bool:
	var condition_results := (_conditions_map.call_by_key(button_id)
			+ _conditions_map.call_by_key(GENERAL_CALLBACK_ID))
	var anti_condition_results := (_anti_conditions_map.call_by_key(button_id)
			+ _anti_conditions_map.call_by_key(GENERAL_CALLBACK_ID))
	return (_disabled or condition_results.any(func(a: bool): return not a)
			or anti_condition_results.any(func(a: bool): return a)
	)
