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
@onready var problem_slot_1 := %ProblemSlot1 as MemoSlot
@onready var problem_slot_2 := %ProblemSlot2 as MemoSlot
@onready var solution_slot := %SolutionSlot as MemoSlot


func _ready() -> void:
	solution_slot.set_empty()
	solution_slot.memo_accepted.connect(_on_memo_accepted)


func _on_memo_accepted(_memo: Memo) -> void:
	slot_filled.emit()


func open_verification_panel() -> void:
	verification_panel.clear_slots()
	verification_panel.show()
	verification_panel.left_slots[0].set_by_memo(problem_slot_1.memo, true)
	verification_panel.left_slots[1].set_by_memo(problem_slot_2.memo, true)


func close_verification_panel() -> void:
	verification_panel.hide()
