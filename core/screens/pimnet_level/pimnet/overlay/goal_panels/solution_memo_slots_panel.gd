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

@onready var verification_panel := %SolutionVerificationPanel as PanelContainer
@onready var problem_slot := %ProblemSlot as MemoSlot
@onready var solution_slot := %SolutionSlot as MemoSlot


func _ready() -> void:
	solution_slot.set_empty()
	solution_slot.memo_accepted.connect(_on_memo_accepted)


func _on_memo_accepted(_memo: Memo) -> void:
	slot_filled.emit()


func set_problem_memo(memo: Memo) -> void:
	verification_panel.correct_memos.clear()
	problem_slot.set_by_memo(memo, true)
	for number in memo.expression.get_numbers():
		verification_panel.correct_memos.append(IntegerMemo.new(number))
