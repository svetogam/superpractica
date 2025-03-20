# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name NumberEffect
extends ScreenEffect

var number: int:
	set(value):
		number = value
		_update_sprites()
@onready var _digit_sprites: Array = [%Ones, %Tens, %Hundreds]


func _update_sprites() -> void:
	# Set sprites
	var number_digits := IntegerMath.get_number_of_digits(number)
	for i in range(_digit_sprites.size()):
		if i <= number_digits - 1:
			var digit := IntegerMath.get_digit_at_place(number, i + 1)
			_digit_sprites[i].animation = str(digit)
		else:
			_digit_sprites[i].animation = "empty"

	# Center sprites
	var offset_x = -(number_digits - 1) * (%Tens.position.x / 2) / %Tens.scale.x
	for sprite in _digit_sprites:
		sprite.offset.x = offset_x


func set_by_effect(original: ScreenEffect) -> void:
	number = original.number


func is_equal_to(other_count: NumberEffect) -> bool:
	return number == other_count.number
