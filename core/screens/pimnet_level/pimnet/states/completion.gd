# SPDX-FileCopyrightText: 2025 Super Practica contributors
#
# SPDX-License-Identifier: AGPL-3.0-or-later

extends State

const SLIDE_DURATION := 0.5
const TARGET_Y := 150.0
const BACKGROUND_COLOR := Color.WHITE
const BACKGROUND_TRANSPARENCY := 0.5


func _enter(_last_state: String) -> void:
	%ModalBarrier.color = BACKGROUND_COLOR
	%ModalBarrier.color.a = 0.0
	%ModalBarrier.show()

	%CompletionNextButton.disabled = not Game.is_level_suggested_after_current()
	%CompletionPanel.show()
	var tween := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%CompletionPanel, "position:y", TARGET_Y, SLIDE_DURATION)
	tween.parallel().tween_property(
			%ModalBarrier, "color:a", BACKGROUND_TRANSPARENCY, SLIDE_DURATION)

	_target.prepare_level_select_requested.emit()
