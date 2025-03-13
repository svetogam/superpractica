# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

# Incomplete. See test_expression_object.gd for what functionality is incomplete.

class_name ExpressionMemo
extends Memo

var expression: ExpressionObject


func _init(p_string := "") -> void:
	expression = ExpressionObject.new(p_string)


func set_by_memo(source: Memo) -> void:
	assert(is_same_type(source))
	expression = ExpressionObject.new(source.get_string())


func set_by_value(p_string: String) -> void:
	expression = ExpressionObject.new(p_string)


func get_value() -> int:
	return expression.evaluate()


func get_string() -> String:
	return expression.get_string(true)


func is_memo_equal(other: Memo) -> bool:
	return (
		other != null
		and is_same_type(other)
		and expression.is_identical(other.expression)
	)
