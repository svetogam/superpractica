# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends InfoSignal

const DIGIT_SIZE := Vector2(32.0, 46.0) # Calculate using Ruler Mode
var number: int:
	set(value):
		number = value
		_update_sprites()
@onready var _digit_sprites: Array = [%Ones, %Tens, %Hundreds]


func get_base_size() -> Vector2:
	var number_digits := IntegerMath.get_number_of_digits(number)
	return Vector2(DIGIT_SIZE.x * number_digits, DIGIT_SIZE.y)


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
