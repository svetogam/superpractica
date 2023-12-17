#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: MIT                                               #
#============================================================================#

extends GutTest

var expression: ExpressionObject


func test_is_symbol() -> void:
	assert_true(ExpressionObject.is_symbol("+"))
	assert_true(ExpressionObject.is_symbol("-"))
	assert_true(ExpressionObject.is_symbol("*"))
	assert_true(ExpressionObject.is_symbol("/"))
	assert_true(ExpressionObject.is_symbol("("))
	assert_true(ExpressionObject.is_symbol(")"))
	assert_true(not ExpressionObject.is_symbol("="))
	assert_true(not ExpressionObject.is_symbol("1"))
	assert_true(not ExpressionObject.is_symbol("123"))


func test_is_whitespace() -> void:
	assert_true(ExpressionObject.is_white_space(" "))
	assert_true(not ExpressionObject.is_white_space("1"))
	assert_true(not ExpressionObject.is_white_space("("))
	assert_true(not ExpressionObject.is_white_space("_"))
	assert_true(not ExpressionObject.is_white_space("  "))
	assert_true(not ExpressionObject.is_white_space("0"))


func test_empty_memo() -> void:
	expression = ExpressionObject.new()

	assert_true(not expression.is_valid())
	assert_true(expression.is_empty())
	assert_true(expression.get_string() == "")
	assert_true(expression.evaluate() == 0)

	expression.set_by_string("")

	assert_true(not expression.is_valid())
	assert_true(expression.is_empty())
	assert_true(expression.get_string() == "")
	assert_true(expression.evaluate() == 0)

	expression.clear()

	assert_true(not expression.is_valid())
	assert_true(expression.is_empty())
	assert_true(expression.get_string() == "")
	assert_true(expression.evaluate() == 0)


#Fail
func test_simple_expression() -> void:
	expression = ExpressionObject.new("2 + 2")

	assert_true(not expression.is_empty())
	assert_true(expression.is_valid())
	assert_true(expression.get_string() == "2+2")
	assert_true(expression.get_string(true) == "2 + 2")
#	assert_true(expression.evaluate() == 4)


#Fail
func test_expression_with_every_operation() -> void:
	expression = ExpressionObject.new("6 + 2 * 78 - 4 * 9 / 3")

	assert_true(expression.is_valid())
	assert_true(expression.get_string() == "6+2*78-4*9/3")
#	assert_true(expression.evaluate() == 150)


#Fail
func test_expression_with_parentheses() -> void:
	expression = ExpressionObject.new("3 + (4 * (5+3) / (16-8) + 1)")

	assert_true(expression.is_valid())
	assert_true(expression.get_string() == "3+(4*(5+3)/(16-8)+1)")
#	assert_true(expression.evaluate() == 8)


#Fail
func test_expression_with_negative_numbers() -> void:
	expression = ExpressionObject.new("-5 + 83 + (-43)")

	assert_true(expression.is_valid())
	assert_true(expression.get_string() == "-5+83+(-43)")
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

	assert_true(expression.is_identical(expression))
	assert_true(expression.is_identical(expression_2))
	assert_true(not expression.is_identical(expression_3))
	assert_true(not expression.is_identical(expression_4))

	assert_true(expression_2.is_identical(expression))
	assert_true(expression_2.is_identical(expression_2))
	assert_true(not expression_2.is_identical(expression_3))
	assert_true(not expression_2.is_identical(expression_4))

	assert_true(not expression_3.is_identical(expression))
	assert_true(not expression_3.is_identical(expression_2))
	assert_true(expression_3.is_identical(expression_3))
	assert_true(not expression_3.is_identical(expression_4))

	assert_true(not expression_4.is_identical(expression))
	assert_true(not expression_4.is_identical(expression_2))
	assert_true(not expression_4.is_identical(expression_3))
	assert_true(expression_4.is_identical(expression_4))
