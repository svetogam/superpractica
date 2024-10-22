#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

#Incomplete. See test_expression_object.gd for what functionality is incomplete.

class_name ExpressionMemo
extends Memo

var expression: ExpressionObject


func _init(string := "") -> void:
	expression = ExpressionObject.new(string)


func set_by_memo(source: Memo) -> void:
	assert(is_same_type(source))
	expression = ExpressionObject.new(source.get_string())


func set_by_value(string: String) -> void:
	expression = ExpressionObject.new(string)


func get_value() -> int:
	return expression.evaluate()


func get_string(kwargs := {"use_spaces": false}) -> String:
	return expression.get_string(kwargs.use_spaces)


func is_memo_equal(other: Memo) -> bool:
	return expression.is_identical(other.expression)
