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


func _ready() -> void:
	get_slot("Slot1").set_memo(IntegerMemo, 1)
	get_slot("Slot2").set_memo(IntegerMemo, 2)
	get_slot("Slot3").set_memo(IntegerMemo, 3)
	get_slot("Slot4").set_memo(IntegerMemo, 4)

	clear_effects()


func _on_slot_changed(_memo: Memo, slot_name: String) -> void:
	clear_effects()
	create_number_effect(slot_name)
