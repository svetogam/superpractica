##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
##############################################################################

class_name StackTracker
extends RefCounted

var _stack: Array
var _stack_position: int
var _have_base_item: bool
var _max_items: int


#Push the initial item after this if have_base_item is true
func _init(p_max_items: int, p_have_base_item:=false) -> void:
	_stack = []
	_stack_position = 0
	_max_items = p_max_items
	_have_base_item = p_have_base_item


func clear() -> void:
	_stack = []
	_stack_position = 0


func push_item(item) -> void:
	_limit_stack_to_position()
	_stack.append(item)
	_limit_stack_to_max_items()
	_stack_position = len(_stack)


func _limit_stack_to_position() -> void:
	while not is_position_at_front():
		_stack.remove_at(len(_stack)-1)


func _limit_stack_to_max_items() -> void:
	while len(_stack) > _max_items:
		_stack.remove_at(0)


func move_position_back() -> void:
	if not is_position_at_back():
		_stack_position -= 1


func move_position_forward() -> void:
	if not is_position_at_front():
		_stack_position += 1


func set_position(new_position: int) -> void:
	if new_position <= 0 or new_position > _stack.size():
		assert(false)
		return

	_stack_position = new_position


func is_position_at_back() -> bool:
	var min_position
	if _have_base_item:
		min_position = 1
	else:
		min_position = 0

	return _stack_position == min_position


func is_position_at_front() -> bool:
	return _stack_position == len(_stack)


func get_current_item():
	if _stack_position == 0:
		return null
	else:
		return _stack[_stack_position-1]


func get_current_position() -> int:
	return _stack_position
