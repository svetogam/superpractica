##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

extends Node

const GENERAL_CALLBACK_ID := "_"
var _button_map: Dictionary
var _disabled := false
var _condition_callbacker := KeyCallbacker.new()
var _anti_condition_callbacker := KeyCallbacker.new()


func set_button_map(p_button_map: Dictionary) -> void:
	_button_map = p_button_map
	update()


func add_button(button_id: String, button: BaseButton) -> void:
	_button_map[button_id] = button
	update()


func disable_all(p_disabled:=true) -> void:
	_disabled = p_disabled
	update()


func connect_button(button_id: String, object: Object, method: String, sought:=true) -> void:
	assert(_button_map.has(button_id))
	if sought == true:
		_condition_callbacker.add(button_id, object, method)
	else:
		_anti_condition_callbacker.add(button_id, object, method)
	update()


func disconnect_button(button_id: String, object: Object, method: String) -> void:
	assert(_button_map.has(button_id))
	if _condition_callbacker.has(button_id):
		_condition_callbacker.remove(button_id, object, method)
	if _anti_condition_callbacker.has(button_id):
		_anti_condition_callbacker.remove(button_id, object, method)
	update()


func connect_general(object: Object, method: String, sought:=true) -> void:
	if sought == true:
		_condition_callbacker.add(GENERAL_CALLBACK_ID, object, method)
	else:
		_anti_condition_callbacker.add(GENERAL_CALLBACK_ID, object, method)
	update()


func disconnect_general(object: Object, method: String) -> void:
	if _condition_callbacker.has(GENERAL_CALLBACK_ID):
		_condition_callbacker.remove(GENERAL_CALLBACK_ID, object, method)
	if _anti_condition_callbacker.has(GENERAL_CALLBACK_ID):
		_anti_condition_callbacker.remove(GENERAL_CALLBACK_ID, object, method)
	update()


func disconnect_all() -> void:
	_condition_callbacker.clear()
	_anti_condition_callbacker.clear()


func update() -> void:
	for button_id in _button_map.keys():
		var button = _button_map[button_id]
		var enable = (not _disabled
				and _condition_callbacker.do_callbacks_return_true(button_id)
				and _condition_callbacker.do_callbacks_return_true(GENERAL_CALLBACK_ID)
				and _anti_condition_callbacker.do_callbacks_return_false(button_id)
				and _anti_condition_callbacker.do_callbacks_return_false(GENERAL_CALLBACK_ID))
		button.disabled = not enable
