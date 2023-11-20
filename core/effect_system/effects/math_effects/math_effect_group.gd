##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

class_name MathEffectGroup
extends ScreenEffectGroup

const NUMBER_EFFECT := preload("number_effect/number_effect.tscn")

const OPERATOR_EFFECTS := {
	"+": preload("signs/plus_effect.tscn"),
}


func give_number(number: int, pos: Vector2, animation:="rise") -> NumberEffect:
	var effect = create_effect(NUMBER_EFFECT, pos)
	effect.number = number
	effect.animate(animation)
	return effect


func give_operator(type: String, pos: Vector2) -> ScreenEffect:
	assert(OPERATOR_EFFECTS.has(type))

	var effect = create_effect(OPERATOR_EFFECTS[type], pos)
	effect.animate("fade_in")
	return effect


func new_number_from_digit_of_original(original: NumberEffect, digit_place: int) -> NumberEffect:
	var digit = IntegerMath.get_digit_at_place(original.number, digit_place)
	var pos = original.get_position_for_digit(digit_place)
	var effect = create_effect(NUMBER_EFFECT, pos)
	effect.number = digit
	effect.scale = original.scale
	return effect
