# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: MIT

extends GdUnitTestSuite

var expression: ExpressionObject


func test_is_symbol() -> void:
	assert_bool(ExpressionObject.is_symbol("+")).is_true()
	assert_bool(ExpressionObject.is_symbol("-")).is_true()
	assert_bool(ExpressionObject.is_symbol("*")).is_true()
	assert_bool(ExpressionObject.is_symbol("/")).is_true()
	assert_bool(ExpressionObject.is_symbol("(")).is_true()
	assert_bool(ExpressionObject.is_symbol(")")).is_true()
	assert_bool(not ExpressionObject.is_symbol("=")).is_true()
	assert_bool(not ExpressionObject.is_symbol("1")).is_true()
	assert_bool(not ExpressionObject.is_symbol("123")).is_true()


func test_is_whitespace() -> void:
	assert_bool(ExpressionObject.is_white_space(" ")).is_true()
	assert_bool(not ExpressionObject.is_white_space("1")).is_true()
	assert_bool(not ExpressionObject.is_white_space("(")).is_true()
	assert_bool(not ExpressionObject.is_white_space("_")).is_true()
	assert_bool(not ExpressionObject.is_white_space("  ")).is_true()
	assert_bool(not ExpressionObject.is_white_space("0")).is_true()


func test_empty_memo() -> void:
	expression = ExpressionObject.new()

	assert_bool(not expression.is_valid()).is_true()
	assert_bool(expression.is_empty()).is_true()
	assert_bool(expression.get_string() == "").is_true()
	assert_bool(expression.evaluate() == 0).is_true()

	expression.set_by_string("")

	assert_bool(not expression.is_valid()).is_true()
	assert_bool(expression.is_empty()).is_true()
	assert_bool(expression.get_string() == "").is_true()
	assert_bool(expression.evaluate() == 0).is_true()

	expression.clear()

	assert_bool(not expression.is_valid()).is_true()
	assert_bool(expression.is_empty()).is_true()
	assert_bool(expression.get_string() == "").is_true()
	assert_bool(expression.evaluate() == 0).is_true()


#Fail
func test_simple_expression() -> void:
	expression = ExpressionObject.new("2 + 2")

	assert_bool(not expression.is_empty()).is_true()
	assert_bool(expression.is_valid()).is_true()
	assert_bool(expression.get_string() == "2+2").is_true()
	assert_bool(expression.get_string(true) == "2 + 2").is_true()
#	assert_true(expression.evaluate() == 4)


#Fail
func test_expression_with_every_operation() -> void:
	expression = ExpressionObject.new("6 + 2 * 78 - 4 * 9 / 3")

	assert_bool(expression.is_valid()).is_true()
	assert_bool(expression.get_string() == "6+2*78-4*9/3").is_true()
#	assert_true(expression.evaluate() == 150)


#Fail
func test_expression_with_parentheses() -> void:
	expression = ExpressionObject.new("3 + (4 * (5+3) / (16-8) + 1)")

	assert_bool(expression.is_valid()).is_true()
	assert_bool(expression.get_string() == "3+(4*(5+3)/(16-8)+1)").is_true()
#	assert_true(expression.evaluate() == 8)


#Fail
func test_expression_with_negative_numbers() -> void:
	expression = ExpressionObject.new("-5 + 83 + (-43)")

	assert_bool(expression.is_valid()).is_true()
	assert_bool(expression.get_string() == "-5+83+(-43)").is_true()
#	assert_true(expression.evaluate() == 35)


#Fail
#func test_invalid_expression_with_only_empty_parentheses() -> void:
#	expression = ExpressionObject.new("()")
#
#	assert_true(not expression.is_valid())
#	assert_true(not expression.is_empty())
#	assert_true(expression.get_string() == "invalid")
#	assert_true(expression.evaluate() == 0)
#
#
#func test_invalid_expression_with_unclosed_parenthesis() -> void:
#	expression = ExpressionObject.new("(2+1)))( -3")
#
#	assert_true(not expression.is_valid())
#	assert_true(not expression.is_empty())
#	assert_true(expression.get_string() == "invalid")
#	assert_true(expression.evaluate() == 0)
#
#
#func test_invalid_expression_with_nonconsecutive_numbers() -> void:
#	expression = ExpressionObject.new("2 1 + 4")
#
#	assert_true(not expression.is_valid())
#	assert_true(not expression.is_empty())
#	assert_true(expression.get_string() == "invalid")
#	assert_true(expression.evaluate() == 0)
#
#
#func test_invalid_expression_with_weird_operators() -> void:
#	expression = ExpressionObject.new("*4 ++ 3 -")
#
#	assert_true(not expression.is_valid())
#	assert_true(not expression.is_empty())
#	assert_true(expression.get_string() == "invalid")
#	assert_true(expression.evaluate() == 0)


func test_check_if_expressions_are_identical() -> void:
	#Same expressions
	expression = ExpressionObject.new("1+2+3")
	var expression_2 := ExpressionObject.new("1 + 2 + 3")
	#Different expressions
	var expression_3 := ExpressionObject.new("1+(2+3)")
	var expression_4 := ExpressionObject.new("3+2+1")

	assert_bool(expression.is_identical(expression)).is_true()
	assert_bool(expression.is_identical(expression_2)).is_true()
	assert_bool(not expression.is_identical(expression_3)).is_true()
	assert_bool(not expression.is_identical(expression_4)).is_true()

	assert_bool(expression_2.is_identical(expression)).is_true()
	assert_bool(expression_2.is_identical(expression_2)).is_true()
	assert_bool(not expression_2.is_identical(expression_3)).is_true()
	assert_bool(not expression_2.is_identical(expression_4)).is_true()

	assert_bool(not expression_3.is_identical(expression)).is_true()
	assert_bool(not expression_3.is_identical(expression_2)).is_true()
	assert_bool(expression_3.is_identical(expression_3)).is_true()
	assert_bool(not expression_3.is_identical(expression_4)).is_true()

	assert_bool(not expression_4.is_identical(expression)).is_true()
	assert_bool(not expression_4.is_identical(expression_2)).is_true()
	assert_bool(not expression_4.is_identical(expression_3)).is_true()
	assert_bool(expression_4.is_identical(expression_4)).is_true()
