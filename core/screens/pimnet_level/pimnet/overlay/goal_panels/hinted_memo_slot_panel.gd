# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends PanelContainer

signal slot_filled

@onready var slot := %HintedMemoSlot as MemoSlot


func _ready() -> void:
	slot.set_faded()
	slot.accept_condition = _accept_condition
	slot.memo_accepted.connect(_on_memo_accepted)


func _accept_condition(memo: Memo) -> bool:
	return slot.memo != null and memo.get_value() == slot.memo.get_value()


func _on_memo_accepted(_memo: Memo) -> void:
	slot_filled.emit()
