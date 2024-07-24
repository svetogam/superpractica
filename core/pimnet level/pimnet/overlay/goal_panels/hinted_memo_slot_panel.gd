#============================================================================#
# This file is part of Super Practica.                                       #
# Copyright (c) 2023 Super Practica contributors                             #
#----------------------------------------------------------------------------#
# See the COPYRIGHT.md file at the top-level directory of this project       #
# for information on the license terms of Super Practica as a whole.         #
#----------------------------------------------------------------------------#
# SPDX-License-Identifier: AGPL-3.0-or-later                                 #
#============================================================================#

extends PanelContainer

signal slot_filled

@onready var slot := %MemoSlot as MemoSlot


func _ready() -> void:
	slot.set_faded()
	slot.accept_condition = _accept_condition
	slot.memo_accepted.connect(_on_memo_accepted)


func _accept_condition(memo: Memo) -> bool:
	return slot.memo != null and memo.get_value() == slot.memo.get_value()


func _on_memo_accepted(_memo: Memo) -> void:
	slot.set_faded(false)
	slot.set_input_output_ability(false, false)
	slot_filled.emit()