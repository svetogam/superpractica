##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name IntegerMemo
extends Memo

var number: int


func _init(p_number:=0) -> void:
	set_by_value(p_number)


func set_by_memo(source: Memo) -> void:
	assert(is_same_type(source))
	set_by_value(source.number)


func set_by_value(p_number: int) -> void:
	number = p_number


func get_value() -> int:
	return number


func get_string(_kwargs:={}) -> String:
	return str(number)


func is_memo_equal(other_memo: Memo) -> bool:
	return number == other_memo.number
