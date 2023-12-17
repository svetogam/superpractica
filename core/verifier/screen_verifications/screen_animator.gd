#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Node

const POST_EQUALITY_CHECK_DELAY := 0.8
const EqualityEffect = preload("effects/equality_effect.tscn")
const EvaluationBar = preload("effects/evaluation_bar_effect.tscn")

var _screen_verifier: ScreenVerifier:
	get = _get_screen_verifier
var _effect_group: MathEffectGroup:
	get = _get_effect_group
@onready var _plan := %Plan as Node2D


func _get_screen_verifier() -> ScreenVerifier:
	assert(get_parent() != null)
	return get_parent()


func _get_effect_group() -> MathEffectGroup:
	assert(_screen_verifier.effect_group != null)
	return _screen_verifier.effect_group


func _animate_to_place(screen_effect: ScreenEffect, destination: Vector2, scale: float,
		callback := Callable()
) -> void:
	screen_effect.animator.move_to_position(destination)
	screen_effect.animator.grow_to_ratio(scale)

	if not callback.is_null():
		screen_effect.animator.move_completed.connect(callback)


#====================================================================
# Equality
#====================================================================

func animate_equality_setup(left_number: NumberEffect, right_number: NumberEffect,
		callback := Callable()
) -> void:
	animate_number_to_equality(left_number, "left", callback)
	animate_number_to_equality(right_number, "right")


func animate_number_to_equality(number: NumberEffect, side: String, callback := Callable()
) -> void:
	var destination: Vector2
	if side == "left":
		destination = _plan.get_equality_left_number_position()
	elif side == "right":
		destination = _plan.get_equality_right_number_position(number.number)
	else:
		assert(false)
	var growth_ratio = _plan.get_equality_number_scale_ratio()
	_animate_to_place(number, destination, growth_ratio, callback)


func animate_equality_check(equal: bool, callback := Callable()) -> void:
	_popup_comparator(equal)

	await Game.wait_for(POST_EQUALITY_CHECK_DELAY)

	if not callback.is_null():
		callback.call()


#====================================================================
# Evaluation
#====================================================================

func animate_evaluation_setup(left_number: NumberEffect, right_number: NumberEffect,
		operator: ScreenEffect, callback := Callable()
) -> void:
	_popup_evaluation_bar()
	animate_number_to_evaluation(left_number, "left", callback)
	animate_number_to_evaluation(right_number, "right")
	animate_operator_to_evaluation(operator)


func animate_number_to_evaluation(number: NumberEffect, side: String,
		callback := Callable()
) -> void:
	var destination: Vector2
	if side == "left":
		destination = _plan.get_evaluation_left_number_position()
	elif side == "right":
		destination = _plan.get_evaluation_right_number_position(number.number)
	else:
		assert(false)
	var growth_ratio = _plan.get_evaluation_number_scale_ratio()
	_animate_to_place(number, destination, growth_ratio, callback)


func animate_operator_to_evaluation(operator: ScreenEffect, callback := Callable()
) -> void:
	var destination = _plan.get_evaluation_operator_position()
	var growth_ratio = _plan.get_evaluation_operator_scale_ratio()
	_animate_to_place(operator, destination, growth_ratio, callback)


#====================================================================
# Digit Equality
#====================================================================

func animate_number_to_digit_reference(number: NumberEffect, callback := Callable()
) -> void:
	var destination = _plan.get_digit_reference_number_position()
	var growth_ratio = _plan.get_digit_reference_number_scale_ratio()
	_animate_to_place(number, destination, growth_ratio, callback)


#====================================================================
# Popups
#====================================================================

func _popup_comparator(equal: bool) -> void:
	var position = _plan.get_equality_comparator_position()
	if equal:
		_popup_equality(position)
	else:
		_popup_inequality(position)


func _popup_equality(position: Vector2) -> void:
	var effect := _effect_group.create_effect(EqualityEffect, position)
	effect.set_type("equality")
	effect.animate("rise")


func _popup_inequality(position: Vector2) -> void:
	var effect := _effect_group.create_effect(EqualityEffect, position)
	effect.set_type("inequality")
	effect.animate("shake")


func _popup_evaluation_bar() -> void:
	var position = _plan.get_evaluation_bar_position()
	var effect := _effect_group.create_effect(EvaluationBar, position)
	effect.animate("fade_in")


func popup_evaluation_result(result: int) -> void:
	var position = _plan.get_equality_left_number_position()
	var effect := _effect_group.give_number(result, position, "fade_in")
	effect.scale *= _plan.get_equality_number_scale_ratio()
