##############################################################################
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
##############################################################################

extends SlotPanel

onready var _memo_slot := $"%MemoSlot"
onready var _clear_button := $"%ClearButton"
onready var _button_0 := $"%Button0"
onready var _button_1 := $"%Button1"
onready var _button_2 := $"%Button2"
onready var _button_3 := $"%Button3"
onready var _button_4 := $"%Button4"
onready var _button_5 := $"%Button5"
onready var _button_6 := $"%Button6"
onready var _button_7 := $"%Button7"
onready var _button_8 := $"%Button8"
onready var _button_9 := $"%Button9"


func _ready() -> void:
	_setup_slot_map()

	_button_0.connect("pressed", self, "_add_digit", [0])
	_button_1.connect("pressed", self, "_add_digit", [1])
	_button_2.connect("pressed", self, "_add_digit", [2])
	_button_3.connect("pressed", self, "_add_digit", [3])
	_button_4.connect("pressed", self, "_add_digit", [4])
	_button_5.connect("pressed", self, "_add_digit", [5])
	_button_6.connect("pressed", self, "_add_digit", [6])
	_button_7.connect("pressed", self, "_add_digit", [7])
	_button_8.connect("pressed", self, "_add_digit", [8])
	_button_9.connect("pressed", self, "_add_digit", [9])
	_clear_button.connect("pressed", self, "_clear")


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
