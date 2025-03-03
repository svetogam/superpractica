#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

class_name NumberEffect
extends ScreenEffect

const NUMBER_TEXTURES := {
	0: preload("res://core/systems/effect_system/graphics/number_0_blue.svg"),
	1: preload("res://core/systems/effect_system/graphics/number_1_blue.svg"),
	2: preload("res://core/systems/effect_system/graphics/number_2_blue.svg"),
	3: preload("res://core/systems/effect_system/graphics/number_3_blue.svg"),
	4: preload("res://core/systems/effect_system/graphics/number_4_blue.svg"),
	5: preload("res://core/systems/effect_system/graphics/number_5_blue.svg"),
	6: preload("res://core/systems/effect_system/graphics/number_6_blue.svg"),
	7: preload("res://core/systems/effect_system/graphics/number_7_blue.svg"),
	8: preload("res://core/systems/effect_system/graphics/number_8_blue.svg"),
	9: preload("res://core/systems/effect_system/graphics/number_9_blue.svg"),
}

var number: int:
	set = _set_number
@onready var _digit_sprites: Array = [%Ones, %Tens, %Hundreds]


func _set_number(value: int) -> void:
	number = value
	_update_sprites()


func _update_sprites() -> void:
	var number_digits := IntegerMath.get_number_of_digits(number)

	for i in range(_digit_sprites.size()):
		if i <= number_digits-1:
			var digit := IntegerMath.get_digit_at_place(number, i+1)
			var texture = NUMBER_TEXTURES[digit]
			_digit_sprites[i].set_texture(texture)
		else:
			_digit_sprites[i].set_texture(null)


func set_by_effect(original: ScreenEffect) -> void:
	number = original.number


func is_equal_to(other_count: NumberEffect) -> bool:
	return number == other_count.number


func get_digit_displacement() -> Vector2:
	return ((_digit_sprites[1].position - _digit_sprites[0].position)
			* %Graphic.scale.x)


#1 for ones place, 2 for tens place, etc.
func get_position_for_digit(digit_place: int) -> Vector2:
	var offset := get_digit_displacement() * scale.x * (digit_place - 1)
	return position + offset
