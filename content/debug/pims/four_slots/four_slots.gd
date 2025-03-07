# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

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
