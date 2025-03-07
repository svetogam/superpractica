# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends Pim


func _ready() -> void:
	%Button0.pressed.connect(_add_digit.bind(0))
	%Button1.pressed.connect(_add_digit.bind(1))
	%Button2.pressed.connect(_add_digit.bind(2))
	%Button3.pressed.connect(_add_digit.bind(3))
	%Button4.pressed.connect(_add_digit.bind(4))
	%Button5.pressed.connect(_add_digit.bind(5))
	%Button6.pressed.connect(_add_digit.bind(6))
	%Button7.pressed.connect(_add_digit.bind(7))
	%Button8.pressed.connect(_add_digit.bind(8))
	%Button9.pressed.connect(_add_digit.bind(9))
	%ClearButton.pressed.connect(_clear)

	_clear()


func _clear() -> void:
	slot.set_memo(IntegerMemo, 0)


func _add_digit(digit: int) -> void:
	var number = slot.value
	number *= 10
	number += digit
	slot.set_memo(IntegerMemo, number)
