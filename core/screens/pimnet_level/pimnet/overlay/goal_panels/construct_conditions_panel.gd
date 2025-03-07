# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends PanelContainer

signal verification_requested

var used_condition_rows: int = 0
@onready var verification_panel := %SolutionVerificationPanel as PanelContainer
@onready var condition_rows: Array = [%ConditionRow1, %ConditionRow2, %ConditionRow3]
@onready var condition_icons: Array = [%ConditionIcon1, %ConditionIcon2, %ConditionIcon3]
@onready var condition_slots: Array = [%ConditionSlot1, %ConditionSlot2, %ConditionSlot3]
@onready var verify_button := %VerifyConditionsButton as Button


func _ready() -> void:
	verify_button.pressed.connect(_on_verify_button_pressed)


func _on_verify_button_pressed() -> void:
	verification_requested.emit()


func add_condition(memo: Memo, icon: Texture2D) -> void:
	condition_icons[used_condition_rows].texture = icon
	condition_slots[used_condition_rows].set_by_memo(memo, true)
	condition_rows[used_condition_rows].visible = true
	verification_panel.correct_memos.append(memo)

	used_condition_rows += 1
