##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name Memo
extends RefCounted


func is_same_type(other_memo: Memo) -> bool:
	return get_class() == other_memo.get_class()


#Virtual
func set_by_value(_value) -> void:
	assert(false)


#Virtual
func set_by_memo(_source: Memo) -> void:
	assert(false)


#Virtual
func get_value():
	assert(false)


#Virtual
func get_string(_kwargs:={}) -> String:
	assert(false)
	return ""


#Returns true if the memos have the same data, not for mathematical equality
#Virtual
func is_memo_equal(_other_memo: Memo) -> bool:
	assert(false)
	return false


func duplicate() -> Memo:
	var new_memo = get_script().new()
	new_memo.set_by_memo(self)
	return new_memo
