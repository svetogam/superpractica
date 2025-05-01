# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends GoalPanel

signal slot_filled

@onready var problem_slot := %ProblemSlot as MemoSlot
@onready var solution_slot := %SolutionSlot as MemoSlot
@onready var check_slot := %SolutionCheckSlot


func _ready() -> void:
	solution_slot.set_empty()
	solution_slot.memo_accepted.connect(_on_memo_accepted)


func reset() -> void:
	stop_verification()
	verification_panel.correct_memos.clear()
	solution_slot.set_empty()
	problem_slot.set_empty()
	solution_slot.memo_input_enabled = true
	solution_slot.suggestion = Game.SuggestiveSignals.NONE
	check_slot.suggestion = Game.SuggestiveSignals.NONE


func start_verification() -> void:
	verification_panel.open()
	solution_slot.suggestion = Game.SuggestiveSignals.NONE


func stop_verification() -> void:
	verification_panel.close()


func succeed() -> void:
	solution_slot.memo_input_enabled = false
	solution_slot.suggestion = Game.SuggestiveSignals.AFFIRM
	check_slot.suggestion = Game.SuggestiveSignals.AFFIRM


func fail() -> void:
	solution_slot.suggestion = Game.SuggestiveSignals.WARN


func _on_memo_accepted(_memo: Memo) -> void:
	slot_filled.emit()


func set_problem_memo(memo: Memo) -> void:
	verification_panel.correct_memos.clear()
	problem_slot.set_by_memo(memo, true)
	for number in memo.expression.get_numbers():
		verification_panel.correct_memos.append(IntegerMemo.new(number))
