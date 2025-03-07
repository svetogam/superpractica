# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name Memo
extends RefCounted

var value:
	get:
		return get_value()
var string: String:
	get:
		return get_string()

func is_same_type(other_memo: Memo) -> bool:
	return get_class() == other_memo.get_class()


# Virtual
func set_by_value(_value) -> void:
	assert(false)


# Virtual
func set_by_memo(_source: Memo) -> void:
	assert(false)


# Virtual
func get_value():
	assert(false)


# Virtual
func get_string() -> String:
	assert(false)
	return ""


#Returns true if the memos have the same data, not for mathematical equality
# Virtual
func is_memo_equal(_other_memo: Memo) -> bool:
	assert(false)
	return false


func duplicate() -> Memo:
	var new_memo = get_script().new()
	new_memo.set_by_memo(self)
	return new_memo
