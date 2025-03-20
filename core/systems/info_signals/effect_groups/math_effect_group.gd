# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name MathEffectGroup
extends ScreenEffectGroup

const NUMBER_EFFECT := preload("uid://cobbyy58sstrk")


func give_number(number: int, pos: Vector2, animation := "rise") -> NumberEffect:
	var effect := create_effect(NUMBER_EFFECT, pos)
	effect.number = number
	effect.animate(animation)
	return effect
