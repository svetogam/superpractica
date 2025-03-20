# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

class_name NumberEffect
extends ScreenEffect

const NUMBER_TEXTURES := {
	0: preload("uid://mjef7w41ffwd"),
	1: preload("uid://0t4p4rrkqxr1"),
	2: preload("uid://dik7uxl22ydqj"),
	3: preload("uid://b72hif1uvhtml"),
	4: preload("uid://c7uguam1aagtr"),
	5: preload("uid://djqvot68bfymn"),
	6: preload("uid://dce351gf436p1"),
	7: preload("uid://dxh0c7ppuevc"),
	8: preload("uid://1f51so35i05f"),
	9: preload("uid://bm458k3udalha"),
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
