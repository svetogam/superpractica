#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends SlotPanel

@export var initial_addend_1_is_empty := false
@export var initial_addend_1: int = 0
@export var initial_addend_2_is_empty := false
@export var initial_addend_2: int = 0
@export var initial_sum_is_empty := false
@export var initial_sum: int = 0
@onready var _addend_1_slot := %Addend1 as MemoSlot
@onready var _addend_2_slot := %Addend2 as MemoSlot
@onready var _sum_slot := %Sum as MemoSlot
@onready var _plus := %Plus as TextureRect


func _ready() -> void:
	_setup_slot_map()


func _setup_slot_map() -> void:
	_setup_slot(_addend_1_slot, "addend_1")
	_setup_slot(_addend_2_slot, "addend_2")
	_setup_slot(_sum_slot, "sum")

	set_slots(initial_addend_1, initial_addend_2, initial_sum)

	if initial_addend_1_is_empty:
		set_slot_empty("addend_1")
	if initial_addend_2_is_empty:
		set_slot_empty("addend_2")
	if initial_sum_is_empty:
		set_slot_empty("sum")


func set_slots(addend_1: int, addend_2: int, sum: int) -> void:
	set_slot(IntegerMemo, addend_1, "addend_1")
	set_slot(IntegerMemo, addend_2, "addend_2")
	set_slot(IntegerMemo, sum, "sum")


func create_plus_effect() -> ScreenEffect:
	assert(_effects != null)

	var effect_position := _plus.global_position + _plus.size/2
	return _effects.give_operator("+", effect_position) as ScreenEffect
