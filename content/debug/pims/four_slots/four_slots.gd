#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends Pim

@onready var _slot_1 := %Slot1 as MemoSlot
@onready var _slot_2 := %Slot2 as MemoSlot
@onready var _slot_3 := %Slot3 as MemoSlot
@onready var _slot_4 := %Slot4 as MemoSlot


func _ready() -> void:
	_setup_slot(_slot_1, "1")
	_setup_slot(_slot_2, "2")
	_setup_slot(_slot_3, "3")
	_setup_slot(_slot_4, "4")

	set_slot(IntegerMemo, 1, "1")
	set_slot(IntegerMemo, 2, "2")
	set_slot(IntegerMemo, 3, "3")
	set_slot(IntegerMemo, 4, "4")

	clear_effects()


func _on_slot_changed(_memo: Memo, slot_name: String) -> void:
	clear_effects()
	create_number_effect(slot_name)
