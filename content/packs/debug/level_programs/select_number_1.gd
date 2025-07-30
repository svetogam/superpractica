# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends LevelProgram


func _ready() -> void:
	super()

	goal_panel.slot.set_memo_as_hint(IntegerMemo, 8)
	goal_panel.slot_filled.connect(complete_level)


func _end() -> void:
	goal_panel.slot_filled.disconnect(complete_level)
