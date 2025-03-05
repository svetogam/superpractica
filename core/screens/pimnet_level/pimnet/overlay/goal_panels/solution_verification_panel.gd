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

var verified_row_numbers: Array = []
var rejected_row_numbers: Array = []
var filled_row_numbers: Array:
	get:
		return verified_row_numbers + rejected_row_numbers
var correct_memos: Array
@onready var rows: Array = [%CheckRow1, %CheckRow2, %CheckRow3, %CheckRow4]
@onready var left_slots: Array = [%LeftSlot1, %LeftSlot2, %LeftSlot3, %LeftSlot4]
@onready var right_slots: Array = [%RightSlot1, %RightSlot2, %RightSlot3, %RightSlot4]
@onready var check_slots: Array = [%CheckSlot1, %CheckSlot2, %CheckSlot3, %CheckSlot4]


func _ready() -> void:
	for slot in left_slots:
		slot.set_empty()
	for slot in right_slots:
		slot.set_empty()


func open() -> void:
	clear_slots()
	show()
	for row_number in range(correct_memos.size()):
		left_slots[row_number].set_by_memo(correct_memos[row_number], true)
		rows[row_number].show()


func close() -> void:
	clear_slots()
	hide()
	for row in rows:
		row.hide()


func affirm_in_row(memo: Memo, row_number: int) -> void:
	right_slots[row_number].set_by_memo(memo)
	right_slots[row_number].set_highlight(MemoSlot.HighlightTypes.AFFIRMATION)
	verified_row_numbers.append(row_number)
	verified_row_numbers.sort()


func reject_in_row(memo: Memo, row_number: int) -> void:
	right_slots[row_number].set_by_memo(memo)
	right_slots[row_number].set_highlight(MemoSlot.HighlightTypes.REJECTION)
	rejected_row_numbers.append(row_number)
	rejected_row_numbers.sort()


func clear_slots() -> void:
	for slot in left_slots:
		slot.set_empty()
		slot.set_highlight(MemoSlot.HighlightTypes.REGULAR)
	for slot in right_slots:
		slot.set_empty()
		slot.set_highlight(MemoSlot.HighlightTypes.REGULAR)
	verified_row_numbers.clear()
	rejected_row_numbers.clear()
