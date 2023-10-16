##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends GutTest

var _integer_memo := IntegerMemo.new()
var _integer_memo_2 := IntegerMemo.new()


func test_set_by_value() -> void:
	_integer_memo.set_by_value(5)

	assert_true(_integer_memo.number == 5)


func test_set_by_memo() -> void:
	_integer_memo_2.set_by_value(12)
	_integer_memo.set_by_memo(_integer_memo_2)

	assert_true(_integer_memo.number == 12)


func test_get_string() -> void:
	_integer_memo.set_by_value(31)

	assert_true(_integer_memo.get_string() == "31")


func test_is_memo_equal() -> void:
	_integer_memo.set_by_value(12)
	_integer_memo_2.set_by_value(12)

	assert_true(_integer_memo.is_memo_equal(_integer_memo_2))
	assert_true(_integer_memo_2.is_memo_equal(_integer_memo))

	_integer_memo.set_by_value(3)

	assert_true(not _integer_memo.is_memo_equal(_integer_memo_2))
	assert_true(not _integer_memo_2.is_memo_equal(_integer_memo))
