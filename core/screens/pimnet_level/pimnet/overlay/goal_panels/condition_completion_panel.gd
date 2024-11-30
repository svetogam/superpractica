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

signal verification_started

var used_condition_rows: int = 0
var verifications: Array = []
@onready var condition_icons: Array = [%ConditionIcon1, %ConditionIcon2]
@onready var left_slots: Array = [%LeftConditionSlot1, %LeftConditionSlot2]
@onready var right_slots: Array = [%RightConditionSlot1, %RightConditionSlot2]
@onready var check_slots: Array = [%CheckConditionSlot1, %CheckConditionSlot2]
@onready var verify_button := %VerifyConditionsButton as Button


func _ready() -> void:
	for slot in right_slots:
		slot.set_empty()
	verify_button.pressed.connect(_on_verify_button_pressed)


func _on_verify_button_pressed() -> void:
	verification_started.emit()


func add_condition(memo: Memo, verification, icon: Texture2D) -> void:
	condition_icons[used_condition_rows].texture = icon
	left_slots[used_condition_rows].set_by_memo(memo, true)
	verifications.append(verification)

	used_condition_rows += 1


func clear_slots() -> void:
	for slot in right_slots:
		slot.set_empty()
