##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends Node

const POST_EQUALITY_CHECK_DELAY := 0.8
const EqualityEffect = preload("effects/equality_effect.tscn")
const EvaluationBar = preload("effects/evaluation_bar_effect.tscn")

var _pack: ScreenVerifier
var _effect_group: MathEffectGroup
@onready var _plan := %Plan as Node2D


func _enter_tree() -> void:
	_pack = get_parent()
	assert(_pack != null)
	_effect_group = _pack.effect_group
	assert(_effect_group != null)


func _animate_to_place(screen_effect: ScreenEffect, destination: Vector2, scale: float,
			callback_object: Object =null, callback_method:="") -> void:
	screen_effect.animator.move_to_position(destination)
	screen_effect.animator.grow_to_ratio(scale)
	if callback_method != "":
		screen_effect.animator.move_completed.connect(Callable(callback_object, callback_method))


#####################################################################
# Equality
#####################################################################

func animate_equality_setup(left_number: NumberEffect, right_number: NumberEffect,
			callback_object: Object =null, callback_method:="") -> void:
	animate_number_to_equality(left_number, "left", callback_object, callback_method)
	animate_number_to_equality(right_number, "right")


func animate_number_to_equality(number: NumberEffect, side: String,
			callback_object: Object =null, callback_method:="") -> void:
	var destination
	if side == "left":
		destination = _plan.get_equality_left_number_position()
	elif side == "right":
		destination = _plan.get_equality_right_number_position(number.number)
	else:
		assert(false)
	var growth_ratio = _plan.get_equality_number_scale_ratio()
	_animate_to_place(number, destination, growth_ratio, callback_object, callback_method)


func animate_equality_check(equal: bool,
			callback_object: Object =null, callback_method:="") -> void:
	_popup_comparator(equal)

	await Game.wait_for(POST_EQUALITY_CHECK_DELAY)

	if callback_method != "":
		callback_object.call(callback_method)


#####################################################################
# Evaluation
#####################################################################

func animate_evaluation_setup(left_number: NumberEffect, right_number: NumberEffect,
			operator: ScreenEffect, callback_object: Object =null, callback_method:="") -> void:
	_popup_evaluation_bar()
	animate_number_to_evaluation(left_number, "left", callback_object, callback_method)
	animate_number_to_evaluation(right_number, "right")
	animate_operator_to_evaluation(operator)


func animate_number_to_evaluation(number: NumberEffect, side: String,
			callback_object: Object =null, callback_method:="") -> void:
	var destination
	if side == "left":
		destination = _plan.get_evaluation_left_number_position()
	elif side == "right":
		destination = _plan.get_evaluation_right_number_position(number.number)
	else:
		assert(false)
	var growth_ratio = _plan.get_evaluation_number_scale_ratio()
	_animate_to_place(number, destination, growth_ratio, callback_object, callback_method)


func animate_operator_to_evaluation(operator: ScreenEffect,
			callback_object: Object =null, callback_method:="") -> void:
	var destination = _plan.get_evaluation_operator_position()
	var growth_ratio = _plan.get_evaluation_operator_scale_ratio()
	_animate_to_place(operator, destination, growth_ratio, callback_object, callback_method)


#####################################################################
# Digit Equality
#####################################################################

func animate_number_to_digit_reference(number: NumberEffect,
			callback_object: Object =null, callback_method:="") -> void:
	var destination = _plan.get_digit_reference_number_position()
	var growth_ratio = _plan.get_digit_reference_number_scale_ratio()
	_animate_to_place(number, destination, growth_ratio, callback_object, callback_method)


#####################################################################
# Popups
#####################################################################

func _popup_comparator(equal: bool) -> void:
	var position = _plan.get_equality_comparator_position()
	if equal:
		_popup_equality(position)
	else:
		_popup_inequality(position)


func _popup_equality(position: Vector2) -> void:
	var effect = _effect_group.create_effect(EqualityEffect, position)
	effect.set_type("equality")
	effect.animate("rise")


func _popup_inequality(position: Vector2) -> void:
	var effect = _effect_group.create_effect(EqualityEffect, position)
	effect.set_type("inequality")
	effect.animate("shake")


func _popup_evaluation_bar() -> void:
	var position = _plan.get_evaluation_bar_position()
	var effect = _effect_group.create_effect(EvaluationBar, position)
	effect.animate("fade_in")


func popup_evaluation_result(result: int) -> void:
	var position = _plan.get_equality_left_number_position()
	var effect = _effect_group.give_number(result, position, "fade_in")
	effect.scale *= _plan.get_equality_number_scale_ratio()
