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

var row_numbers: Array:
	get:
		return range(left_slots.size())
var verified_row_numbers: Array = []
var rejected_row_numbers: Array = []
var filled_row_numbers: Array:
	get:
		return verified_row_numbers + rejected_row_numbers
var empty_row_numbers: Array:
	get = get_empty_row_numbers
@onready var left_slots: Array = [%LeftSlot1, %LeftSlot2]
@onready var right_slots: Array = [%RightSlot1, %RightSlot2]
@onready var check_slots: Array = [%CheckSlot1, %CheckSlot2]


func _ready() -> void:
	for slot in left_slots:
		slot.set_empty()
	for slot in right_slots:
		slot.set_empty()


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


func get_empty_row_numbers() -> Array:
	var array: Array = []
	for row_number in row_numbers:
		if not filled_row_numbers.has(row_number):
			array.append(row_number)
	return array
