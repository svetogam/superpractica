# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends GoalPanel

signal slot_filled

@onready var slot := %HintedMemoSlot as MemoSlot


func _ready() -> void:
	slot.accept_condition = _accept_condition
	slot.memo_accepted.connect(_on_memo_accepted)


func reset() -> void:
	slot.memo_input_enabled = true
	slot.set_empty()
	slot.suggestion = Game.SuggestiveSignals.NONE


func succeed() -> void:
	slot.memo_input_enabled = false
	slot.suggestion = Game.SuggestiveSignals.AFFIRM


func _accept_condition(memo: Memo) -> bool:
	return slot.memo != null and memo.get_value() == slot.memo.get_value()


func _on_memo_accepted(_memo: Memo) -> void:
	slot_filled.emit()
