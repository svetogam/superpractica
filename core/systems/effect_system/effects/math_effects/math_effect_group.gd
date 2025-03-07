# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name MathEffectGroup
extends ScreenEffectGroup

const NUMBER_EFFECT := preload("number_effect/number_effect.tscn")


func give_number(number: int, pos: Vector2, animation := "rise") -> NumberEffect:
	var effect := create_effect(NUMBER_EFFECT, pos)
	effect.number = number
	effect.animate(animation)
	return effect


func new_number_from_digit_of_original(original: NumberEffect, digit_place: int
) -> NumberEffect:
	var digit := IntegerMath.get_digit_at_place(original.number, digit_place)
	var pos := original.get_position_for_digit(digit_place)
	var effect := create_effect(NUMBER_EFFECT, pos)
	effect.number = digit
	effect.scale = original.scale
	return effect
