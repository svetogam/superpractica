#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends SlotPim

@onready var _memo_slot := %MemoSlot as MemoSlot
@onready var _clear_button := %ClearButton as Button
@onready var _button_0 := %Button0 as Button
@onready var _button_1 := %Button1 as Button
@onready var _button_2 := %Button2 as Button
@onready var _button_3 := %Button3 as Button
@onready var _button_4 := %Button4 as Button
@onready var _button_5 := %Button5 as Button
@onready var _button_6 := %Button6 as Button
@onready var _button_7 := %Button7 as Button
@onready var _button_8 := %Button8 as Button
@onready var _button_9 := %Button9 as Button


func _ready() -> void:
	_setup_slot_map()

	_button_0.pressed.connect(_add_digit.bind(0))
	_button_1.pressed.connect(_add_digit.bind(1))
	_button_2.pressed.connect(_add_digit.bind(2))
	_button_3.pressed.connect(_add_digit.bind(3))
	_button_4.pressed.connect(_add_digit.bind(4))
	_button_5.pressed.connect(_add_digit.bind(5))
	_button_6.pressed.connect(_add_digit.bind(6))
	_button_7.pressed.connect(_add_digit.bind(7))
	_button_8.pressed.connect(_add_digit.bind(8))
	_button_9.pressed.connect(_add_digit.bind(9))
	_clear_button.pressed.connect(_clear)


func _setup_slot_map() -> void:
	_setup_slot(_memo_slot)
	_clear()


func _clear() -> void:
	set_slot(IntegerMemo, 0)


func _add_digit(digit: int) -> void:
	var number = get_slot_value()
	number *= 10
	number += digit
	set_slot(IntegerMemo, number)
