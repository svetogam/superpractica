##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Node2D

#####################################################################
# Equality
#####################################################################

func get_equality_comparator_position() -> Vector2:
	return %EqualityComparator.global_position


func get_equality_left_number_position() -> Vector2:
	return %EqualityLeftNumber.global_position


func get_equality_right_number_position(number: int) -> Vector2:
	var digits = IntegerMath.get_number_of_digits(number)
	var digit_offset = Vector2.ZERO
	if digits > 1:
		digit_offset = (digits - 1) * _get_equality_digit_difference()

	return %EqualityRightNumber.global_position + digit_offset


func _get_equality_digit_difference() -> Vector2:
	return (-%EqualityLeftNumber.get_digit_displacement() * get_equality_number_scale_ratio())


func get_equality_number_scale_ratio() -> float:
	return %EqualityLeftNumber.scale.x


#####################################################################
# Evaluation
#####################################################################

func get_evaluation_bar_position() -> Vector2:
	return %EvalBar.global_position


func get_evaluation_operator_position() -> Vector2:
	return %EvalOperator.global_position


func get_evaluation_left_number_position() -> Vector2:
	return %EvalLeftNumber.global_position


func get_evaluation_right_number_position(number: int) -> Vector2:
	var digits = IntegerMath.get_number_of_digits(number)
	var digit_offset = Vector2.ZERO
	if digits > 1:
		digit_offset = (digits - 1) * _get_evaluation_digit_difference()

	return %EvalRightNumber.global_position + digit_offset


func _get_evaluation_digit_difference() -> Vector2:
	return (-%EvalLeftNumber.get_digit_displacement() * get_evaluation_number_scale_ratio())


func get_evaluation_number_scale_ratio() -> float:
	return %EvalLeftNumber.scale.x


func get_evaluation_operator_scale_ratio() -> float:
	return %EvalOperator.scale.x


#####################################################################
# Digit Reference
#####################################################################

func get_digit_reference_number_position() -> Vector2:
	return %DigitReferenceNumber.global_position


func get_digit_reference_number_scale_ratio() -> float:
	return %DigitReferenceNumber.scale.x
